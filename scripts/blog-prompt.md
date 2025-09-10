Write a technical blog post announcing Radius {RELEASE_NAME} for developers and platform engineers.

Release notes:
{RELEASE_NOTES}
{BLOG_CONTEXT}

Context for the blog post generation:
- Radius documentation: https://docs.radapp.io/
- Radius GitHub repository: https://github.com/radius-project/radius
- Radius blog repository: https://github.com/radius-project/blog
- Style and formatting guidelines: https://github.com/radius-project/blog/blob/re/ab/radblog/guide/contribution-guide.md

Requirements:
- Target audience: experienced developers, platform engineers, DevOps practitioners
- Focus on concrete functionality and implementation details with technical reasoning
- Technical depth over marketing fluff
- Avoid marketing language like "we're excited", "with open arms", "happy building"
- CRITICAL: Only include information that is explicitly stated in the release notes - do not expand, infer, or add details
- Only include code examples, configuration snippets, or commands that are explicitly mentioned in the release notes
- Do NOT make up code examples following common patterns - only use code examples that are specifically mentioned in the release notes
- Do NOT make up documentation links - only use links that are specifically mentioned in the release notes or that you can verify from the Radius documentation
- If you cannot verify information from the release notes, do not include it
- 800-1000 words of substantive technical content
- Professional, matter-of-fact tone
- Avoid repetitive summaries or conclusions that restate what was already covered
- Follow the style and formatting guidelines in the context links above

Structure:
- Start immediately with introductory content - Do not include a title or heading since the Hugo front matter already provides the title
- Direct introduction stating what's new in this release and a link to changelog or release notes
- Key Features as the main sections, with subheadings for each feature if applicable
- Technical summary of key features with implementation details and code examples demonstrating usage within the key features. Call out breaking changes within the features if applicable and not in a separate section.
- Conclude with this standard "Learn more and Get Involved" section:

## Learn more and Get Involved

We would love for you to join us to help build Radius:

- Try the [Radius Todo List Application](https://github.com/Reshrahim/todoapp-ai)
- Join our monthly community meeting to see demos and hear the latest updates (join the [Radius Google Group](https://groups.google.com/g/radapp_io) to get email announcements)
- Join the discussion or ask for help on the [Radius Discord server](https://aka.ms/radius/discord)
- Subscribe to the [Radius YouTube channel](https://www.youtube.com/@radapp_io) for more demos

Generate only the blog content (no frontmatter). Be technical, be specific, avoid fluff.