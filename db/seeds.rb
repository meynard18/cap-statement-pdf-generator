cs = CapabilityStatement.create!(
  company_name: "Abcd Solutions LLC",
  cage_code: "AB123",
  uei: "XYZ9LMN456PQR",
  accepts_credit_cards: true,
  naics_codes: [ "541511", "541512", "541519" ],
  ai_output: {
    introduction: "Abcd Solutions LLC is a Veteran-Owned software development firm that helps government agencies modernize outdated systems and build secure, accessible applications. We focus on compliance with standards, rapid delivery, and user-centered solutions that improve mission performance.",
    core_competencies: [
      "Custom web application development",
      "API development, integration, and documentation (internal and external systems)",
      "Modernization of legacy systems using secure, scalable cloud technologies",
      "Dashboard and reporting tools for admin panels, user portals, and internal analytics",
      "Accessibility-focused web development (Section 508/ADA)",
      "Rapid prototyping and delivery of minimum viable products (MVPs)"
    ],
    differentiators: [
      "Veteran-owned small business led by a hands-on principal, ensuring direct accountability and faster decisions.",
      "Federal-facing experience supporting U.S. Congressional and Senatorial websites under a prime vendor, ensuring compliance and accessibility.",
      "Agile development with Section 508 compliance built-in, scalable from small projects to large prime contracts while staying lean and responsive."
    ],
    past_performance: [
      "U.S. Congress & Senate Websites – Maintained and enhanced 10+ Congressional and Senatorial websites with Section 508 compliance, supporting millions of constituents.",
      "Commercial SaaS Platform – Built and maintained SaaS modules powering multi-tenant storefronts and product configurators for nationwide retailers."
    ]
  }.to_json
)

CompanyContact.create!(
  capability_statement: cs,
  name: "John Doe",
  email: "contact@abcdsolutions.com",
  phone: "123-456-7890",
  website: "https://abcdsolutions.com",
  street: "123 Main St",
  city: "Springfield",
  state: "IL",
  postal_code: "62704"
)
