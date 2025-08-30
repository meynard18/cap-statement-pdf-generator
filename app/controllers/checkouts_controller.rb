class CheckoutsController < ApplicationController
  def create
    cs = CapabilityStatement.find(params[:id])
    # debugger
    session = Stripe::Checkout::Session.create(
      mode: "payment",
      payment_method_types: ["card"],
      line_items: [{
        price_data: {
          currency: "usd",
          unit_amount: 3900, # $39.00
          product_data: { name: "Capability Statement PDF" }
        },
        quantity: 1
      }],
      metadata: { capability_statement_id: cs.id },
      success_url: capability_statement_url(cs),
      cancel_url: capability_statement_url(cs)
    )

    redirect_to session.url, allow_other_host: true
  end
end
