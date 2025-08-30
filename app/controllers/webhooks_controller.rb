class WebhooksController < ApplicationController
  protect_from_forgery except: :stripe

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET"]
        )
    Rails.logger.info "👉 Stripe event type: #{event['type']}"
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    # debugger
    puts '###########'
    puts '###########'
    puts '###########'
    puts '###########'
    puts '###########'
    puts '###########'
    if event["type"] == "checkout.session.completed"
      puts "??????"
      puts "??????"
      puts "??????"
      puts "??????"
      puts "??????"
      puts "??????"
      puts "??????"
      puts "??????"
      session = event["data"]["object"]
      cs_id = session.metadata["capability_statement_id"]

      if cs_id.present?
        CapabilityStatement.find(cs_id).update!(paid: true)
        Rails.logger.info "✅ CapabilityStatement #{cs_id} marked as paid"
      else
        Rails.logger.warn "⚠️ No capability_statement_id in metadata"
      end
    end

    head :ok
  end
end
