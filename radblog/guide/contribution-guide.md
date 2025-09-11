# Radius Blog Contribution Guidelines

## Overview

The Radius project blog serves as a vital communication channel between the Radius community and the broader cloud-native community. This guide establishes standards for creating content that is both technically accurate and accessible to developers worldwide. 

All blog contributions must be relevant to Radius and the broader cloud-native ecosystem. Content should provide genuine value to readers through actionable insights, practical examples, or meaningful technical depth.

## Content Types

1. **Feature announcements** introduce new capabilities with context about problems solved and practical applications in real-world workflows.

2. **Community stories** showcase how organizations use Radius to solve specific problems, focusing on implementation details and measurable outcomes. These highlight small, focused use cases.

3. **Release announcements** balance comprehensive coverage with readability, highlighting significant changes and providing clear upgrade paths. Breaking changes require detailed migration steps.

4. **Integration guides** demonstrate real scenarios with Radius and other cloud-native technologies, including configuration examples and troubleshooting guidance.

5. **Case studies** provide detailed analysis of production deployments, examining usage patterns, implementation challenges, and solutions developed.

## Target Audience

1. **Platform engineers and Developers** need architectural guidance, best practices, and integration patterns for internal developer platforms.

2. **Enterprise decision makers** require strategic insights, implementation considerations, and evidence of successful deployments at scale.

3. **Open source contributors** seek detailed technical explanations, architecture discussions, and contribution guidance.

## Content Requirements

- Length of the blog post should be between 800-1000 words
- Every statement must be verifiable through documentation, code examples, or reproducible demonstrations
- Include complete, working code that readers can adapt and use successfully
- Provide actionable insights that readers can apply immediately
- Focus on demonstrable facts and measurable outcomes, avoiding promotional language
- Ensure all external references point to authoritative, up-to-date sources

## Location and structure of post content

Create a new markdown file for each blog post in the appropriate year directory under `radblog/content/posts`. The file name should be the title of the blog post, with hyphens in place of spaces. For example, the file name for a blog post titled "Hello world" would be `hello-world.md`.

The content of the blog post markdown file should be in the following format:

```md
---
date: "YYYY-MM-DDT07:00:00-07:00"
title: "Blog post title"
linkTitle: "Shorter blog post title in links pane"
author: "[Firstname Lastname](<link_to_linkedin_or_github>)"
type: blog
---

Blog post content here.
```

## Article Structure

- **Title**: Clear and descriptive, working well in search results and social media
- **Introduction**: Establish context and explain the problem being addressed
- **Main content**: Logical progression with descriptive headings and practical examples
- **Conclusion**: Summarize key takeaways and provide clear next steps
- **Learn More**: Link to official documentation and authoritative sources

## Writing Guidelines

### Style and Tone
- **Conversational and friendly**: Make technical topics accessible without being frivolous
- **User-focused**: Write in second person ("you") rather than first person ("we")
- **Clear and concise**: Use simple, direct language accessible globally
- **Active voice**: Make content more direct and engaging
- **Present tense**: Use when describing current features and capabilities
- **Objective**: Avoid promotional language, superlatives, and unsupported claims

### Language Standards
- **Global accessibility**: Avoid idioms, cultural references, and region-specific examples
- **American English spelling**: Use standard conventions consistently
- **Terminology consistency**: Use established Radius terminology throughout
- **Inclusive language**: Follow cloud-native community standards
- **Technical accuracy**: All statements must be verifiable and current
- **Descriptive links**: Use meaningful text describing destination content
- **Conditional clarity**: Put conditions before instructions

### Content Quality Standards
- **Evidence-based**: Support all claims with documentation, code, or examples
- **Practical focus**: Include working code examples and step-by-step instructions
- **No pre-announcements**: Avoid announcing unavailable future features
- **Avoid speculation**: Don't make undocumented assumptions about user needs
- **No redundancy**: Each section should provide unique value
- **Technical depth**: Provide sufficient detail for understanding and implementation
- **User-centric**: Focus on what users can accomplish

## Formatting Standards

### Typography
- **Proper nouns**: Capitalize Radius entities including: Applications, Environments, Recipes, Resource Types, Containers, Secrets, Routes, Gateways, Resource Groups
- **Headings**: Use sentence case (first word and proper nouns only)
- **File names**: Use kebab-case (`radius-release-guide.md`)
- **UI elements**: Use **bold** for buttons, menus, and dialog boxes
- **Code elements**: Use `monospace` for function names, variables, and file paths
- **Serial commas**: Use consistently in lists of three or more items

### Code and Technical Content
- **Code blocks**: Use fenced blocks with language specification for syntax highlighting
    
    ```bash
    # Example bash code block
    ```
- **Commands**: Separate multiple commands into individual blocks
- **Output**: Show expected output in separate blocks
- **File paths**: Use backticks for file names and paths
- **Placeholders**: Use descriptive names and enclose them in angle brackets (`<YOUR-APPLICATION-NAME>` not `app1`)

### Visual Content
- **Images**: Use high-resolution or vector images with Hugo shortcode `img`

   ```
   {{< image src="images/<your_image_name>" alt="Screenshot of image x" width="500" >}}
   ```
- **Alt text**: Provide descriptive text explaining what images show
- **Consistency**: Maintain consistent visual styling within posts

### Links and References
- **Descriptive text**: Use specific descriptions instead of "click here"
- **Internal links**: Connect to relevant Radius documentation and blog posts
- **External links**: Point to authoritative, current sources
- **GitHub references**: Include links to issues, PRs, and commits when relevant

## Submission Process

### Before Submitting
1. **Self-review**: Check technical accuracy, style adherence, and target audience clarity
2. **Technical review**: Have domain experts verify accuracy and completeness
3. **Editorial review**: Ensure clarity, grammar, and style consistency

### Pull Request Requirements
- **Branch naming**: Use descriptive names (`blog/radius-app-graph`)
- **Commit messages**: Follow conventional commit format
- **Description**: Explain post topic, target audience, and key points
- **Staging site**: A staging site will automatically get created and linked to PR to review and test