## Guide for Blog Posts

### Picking a topic

Any content that is relevant to the Radius project and the open-source community is welcome. Think about the topics in Radius that you are passionate about and would like to share with the community. Some of the examples includes, but is not limited to:

- New features in the Radius project
    - Getting started with a particular feature
    - Technical deep dives into the feature
- Customer case studies
    - How customers are using Radius to solve their problems
    - Success stories of customers using Radius
- Comparison with other similar projects and how Radius is different
- Milestones and achievements of the Radius project
- Any problem that you solved in Radius that might be useful for others

### Blog post structure

- **Title**: The title should be clear, concise and should give a brief idea about the content of the blog post.

- **Introduction**: The introduction should give a brief overview of the topic that you are going to discuss in the blog post. It should be engaging and should make the reader want to read more. Assume you are talking to a reader who is completely new to the topic. Summarize the introduction in such a way that it is easy to understand the problem space for a beginner.

- **Sub sections**: The blog post should be split into multiple sections to make it easier for the reader to navigate through the blog post. Each section should have a clear heading that gives an idea about the content of the section. The section headings themselves should tell a story and should be able to convey the message of the blog post.

- **Closing note**: The closing note should summarize the key points discussed in the blog post. It should also give a brief idea about what is expected of the reader next. It can be a call to action to checkout Radius, get started on contributing to Radius or a suggestion to try out something in Radius. Here is an example [Learn More and Contribute](https://blog.radapp.io/posts/2024/02/27/understand-your-entire-application-with-the-radius-application-graph/#learn-more-and-contribute).

- **References**: If you are referring to any external sources, make sure to provide the references at the end of the blog post. This will help the reader to understand the context better and also to explore more about the topic.

### Writing style 

- **Tone**: The tone of the blog post should be friendly and conversational. It should be easy to read and understand. Active voice is preferred over passive voice.

- **Language**: Language should be simple and easy to understand. 
    1. Avoid using jargon and technical terms that might be difficult for a beginner to understand. If you are using any technical terms, make sure to explain them in simple terms. 
    1. Avoid condescending language. Assume that the reader is new to the topic and explain things in a simple way.
    1. Avoid using phrases that are not open-source friendly. For example, instead of using "master" branch, use "main" branch. instead of using "team" refer to them as "community"
    1. Avoid using superlatives and exaggerations. Be honest and transparent in your writing.

- **Casing**: Capitalize the proper nouns eg: Radius, Bicep, Recipes. Use [sentence casing](https://apastyle.apa.org/style-grammar-guidelines/capitalization/sentence-case) for title and section headings.

- **Length**: The blog post should be concise and to the point. Avoid long paragraphs and try to split the content into multiple sections.

- **Images**: Add images wherever you can help the reader understand the content with a visual representation. This could be an architecture diagram, or a simple flow diagram that conveys the overall picture. If you are using images in the blog post, make sure to use the following `image` shortcode. 

    ```markdown
    {{< image src="<imagepath>" alt="<alt text>" width="750" >}}
    ```
    Images should follow the same theme and color within the blog post. You can use some of the example Radius diagrams from the [Radius Diagrams](https://microsoft.sharepoint.com/:p:/t/radiuscoreteam/EZ4-G5-M5HxGi0ZPpOtiP-cBISV4ui98AF-N05aSXBg9vA?e=DiVKUz) and build on top of it.

- **Code snippets**: If you are using code snippets in the blog post, make sure to use triple backticks ```<language> to wrap the code. This will help the reader to understand that it is a code snippet. 
    ```bash
    rad deploy app.bicep
    ```
- **Links**: If you are referring to any external sources, make sure to provide the links in the blog post. This will help the reader to explore more about the topic. Use the following format to add links in the blog post.
    ```markdown
    [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep)
