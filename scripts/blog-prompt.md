Write a technical blog post announcing Radius {RELEASE_NAME} for developers and platform engineers.

Release notes:
{RELEASE_NOTES}
	@@ -7,23 +7,21 @@ Style context from previous posts:
{BLOG_CONTEXT}

Context for the blog post generation:
- Radius documentation: https://docs.radapp.io/
- Radius GitHub repository: https://github.com/radius-project/radius
- Radius blog repository: https://github.com/radius-project/blog

Requirements:
- Technical depth over marketing fluff
- Target audience: experienced developers, platform engineers, DevOps practitioners
- Focus on concrete functionality and implementation details with technical reasoning
- Avoid marketing language like "we're excited", "with open arms", "happy building"
- CRITICAL: Only include information that is explicitly stated in the release notes - do not expand, infer, or add details
- Only include code examples, configuration snippets, or commands that are explicitly mentioned in the release notes
- Do NOT make up documentation links - only use links that are specifically mentioned in the release notes
- If you cannot verify information from the release notes, do not include it
- Stick strictly to what is documented in the provided release notes
- 800-1000 words of substantive technical content
- Professional, matter-of-fact tone
- Avoid repetitive summaries or conclusions that restate what was already covered

Structure:
- Direct introduction stating what's new in this release
- Technical summary of key features with implementation details and code examples demonstrating usage within the key features
- Breaking changes or migration notes if applicable
- Conclude with this standard "Learn more and Get Involved" section:

## Learn more and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos

Generate only the blog content (no frontmatter). Be technical, be specific, avoid fluff.