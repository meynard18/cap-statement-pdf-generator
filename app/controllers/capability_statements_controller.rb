class CapabilityStatementsController < ApplicationController
    before_action :find_cap_statement, only: %i[ show edit ]
  def new
    @capability_statement = CapabilityStatement.new
    @capability_statement.build_company_contact
  end

  def create
    statement_params = cap_statement_params
    statement_params[:naics_codes] = params[:capability_statement][:naics_codes].split(",").map(&:strip) if params[:capability_statement][:naics_codes].present?
    @capability_statement = CapabilityStatement.new(statement_params)
    # debugger
    if @capability_statement.save
      inputs = {
        company_name: @capability_statement.company_name,
        core_competencies: @capability_statement.core_competencies,
        differentiators: @capability_statement.differentiators,
        past_performance: @capability_statement.past_performance,
        naics_codes: @capability_statement.naics_codes
      }.to_json

      ai_output = OpenAiService.new.generate_capability_statement(inputs)
      @capability_statement.update(ai_output: ai_output)

      redirect_to @capability_statement
    else
      render :new
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
    puts "######"
    puts @capability_statement.inspect
    puts "######"
  end

  private

  def find_cap_statement
    @capability_statement = CapabilityStatement.find(params[:id])
  end

  def cap_statement_params
    params.require(:capability_statement).permit(:company_name, :introduction, :core_competencies, :differentiators, :past_performance, :cage_code, :uei, :accepts_credit_cards, :ai_output, :company_logo, naics_codes: [], certifications: [],
    company_contact_attributes: [ :name, :email, :phone, :website, :website, :street, :city, :state, :postal_code ]).tap do |whitelisted|
      whitelisted[:certifications]&.reject!(&:blank?)
    end
  end
end
