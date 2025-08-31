class CapabilityStatementsController < ApplicationController
    before_action :find_cap_statement, only: %i[ show edit update ]
  def new
    @capability_statement = CapabilityStatement.new
    @capability_statement.build_company_contact
  end

  # def create
  #   statement_params = cap_statement_params
  #   statement_params[:naics_codes] = params[:capability_statement][:naics_codes].split(",").map(&:strip) if params[:capability_statement][:naics_codes].present?
  #   @capability_statement = CapabilityStatement.new(statement_params)

  #   if @capability_statement.save
  #     inputs = {
  #       # company_name: @capability_statement.company_name,
  #       core_competencies: @capability_statement.core_competencies,
  #       differentiators: @capability_statement.differentiators,
  #       past_performance: @capability_statement.past_performance,
  #       # naics_codes: @capability_statement.naics_codes
  #     }.to_json

  #     ai_output = OpenAiService.new.generate_capability_statement(inputs)
  #     @capability_statement.update(ai_output: ai_output)

  #     redirect_to @capability_statement
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  def create
    statement_params = cap_statement_params
    statement_params[:naics_codes] = params[:capability_statement][:naics_codes].split(",").map(&:strip) if params[:capability_statement][:naics_codes].present?

    @capability_statement = CapabilityStatement.new(statement_params)

    if @capability_statement.save
      # Normalize input so ai_output ALWAYS has arrays
      ai_output = {
        "introduction"      => params[:capability_statement][:introduction].to_s.strip,
        "core_competencies" => params[:capability_statement][:core_competencies].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?),
        "differentiators"   => params[:capability_statement][:differentiators].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?),
        "past_performance"  => params[:capability_statement][:past_performance].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
      }

      # Save normalized structure first
      @capability_statement.update(ai_output: ai_output)

      # Then call OpenAI to enrich
      inputs = ai_output.merge(company_name: @capability_statement.company_name, naics_codes: @capability_statement.naics_codes).to_json
      enriched_ai_output = OpenAiService.new.generate_capability_statement(inputs)

      @capability_statement.update(ai_output: enriched_ai_output)

      redirect_to @capability_statement
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "capability_statement_#{@capability_statement.id}",
              template: "capability_statements/show",
              layout: "pdf",
              margin: { top: 0, bottom: 0, left: 0, right: 0 },
              locals: { capability_statement: @capability_statement }
      end
    end
  end

  def edit
    ai = @capability_statement.normalized_ai_output
    @capability_statement.introduction ||= ai["introduction"]
    @capability_statement.core_competencies ||= ai["core_competencies"]&.join("\n")
    @capability_statement.differentiators  ||= ai["differentiators"]&.join("\n")
    @capability_statement.past_performance ||= ai["past_performance"]&.join("\n")
  end

  def update
    ai_output = @capability_statement.ai_output
    ai_output = JSON.parse(ai_output) if ai_output.is_a?(String)
    ai_output ||= {}

    ai_output["introduction"] = params[:capability_statement][:introduction]
    ai_output["core_competencies"] = params[:capability_statement][:core_competencies].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
    ai_output["differentiators"]   = params[:capability_statement][:differentiators].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
    ai_output["past_performance"]  = params[:capability_statement][:past_performance].to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)

    statement_params = cap_statement_params
    statement_params[:naics_codes] = params[:capability_statement][:naics_codes].split(",").map(&:strip) if params[:capability_statement][:naics_codes].present?

    if @capability_statement.update(statement_params.merge(ai_output: ai_output))
      redirect_to @capability_statement, notice: "Capability statement updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def find_cap_statement
    @capability_statement = CapabilityStatement.find(params[:id])
  end

  def parsed_ai_output(statement)
    output = statement.ai_output
    return {} if output.blank?

    output.is_a?(String) ? JSON.parse(output) : output
  end

  def cap_statement_params
    params.require(:capability_statement).permit(:company_name, :introduction, :core_competencies, :differentiators, :past_performance, :cage_code, :uei, :accepts_credit_cards, :ai_output, :company_logo, naics_codes: [], certifications: [],
    company_contact_attributes: [ :name, :email, :phone, :website, :website, :street, :city, :state, :postal_code ]).tap do |whitelisted|
      whitelisted[:certifications]&.reject!(&:blank?)
    end
  end
end
