require "openai"

class OpenAiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def generate_capability_statement(inputs)
    prompt = <<~PROMPT
      You are a senior federal proposal writer with deep knowledge of government contracting.
      Using the company inputs below, produce a capability statement in this EXACT JSON schema:
      {
        "introduction": "",
        "core_competencies": [],
        "differentiators": [],
        "past_performance": []
      }

      Formatting rules:
      - Return ONLY valid JSON. No markdown, no prose before/after.
      - **All bullets must read as natural sentences. No shorthand, symbols, or arrows.**
      - Avoid vague marketing terms ("innovative", "best-in-class", etc.).
      - Expand acronyms (e.g., "API" → "API development and integration").
      - Keep fluff under 100%.
      - **If a section has no input, completely omit that field from the JSON (do not include empty arrays or placeholders).**
      - If you cannot comply with the above rules, return exactly: {}

      Section rules:
      - **Introduction**: Write one short paragraph (2–3 sentences) describing the company, its mission, and how it helps solve problems for federal clients. No bullets or lists.
      - **Core Competencies**: 4–6 bullets. Write as capabilities (what the company *can do*), not achieved outcomes. Use phrasing such as “to improve,” “designed to,” or “enabling.” Include compliance standards where relevant. If a section has no input, completely omit that field from the JSON (do not include empty arrays or placeholders).
      - **Differentiators:** 3-5 bullets. Each bullet must highlight a unique attribute or approach + Explain how it directly benefits federal agencies.
      - **Past Performance**: 2–5 bullets. Each bullet must include (1) the client or agency, (2) the delivered solution or service, and (3) the tangible result or impact. Mention compliance standards where relevant. Write as full sentences, not shorthand.
      - Only include past performance explicitly mentioned in the input. Do not invent or assume.
      Input notes: #{inputs}

      Output:
    PROMPT


    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [ { role: "user", content: prompt } ],
        temperature: 0.3
      }
    )

    response.dig("choices", 0, "message", "content")
  end
end
