## Guide for Writing Blog Posts

### Picking a Topic

Any content that is relevant to the Radius project and the open-source community is welcome. Think about the topics in Radius that you are passionate about and would like to share with the community. When you pick a topic, also think about the target audience for the blog post. Audiences could any of the following 
1. Enterprise Decision makers (CTO, Solution Architect) who are looking to understand how Radius can help with their cloud native strategy, 
2. Platform engineers who are looking to extend Radius for their internal developer platform
3. IT operators / Developers who are looking to get started with using a Radius feature 
4. Open-source contributor who is looking to contribute to Radius.

Note that there might be overlap between these personas as individuals tend to wear multiple hats. Defining a primary target audience for your blog post will help you understand how you should frame the content in the blog post and the level of detail that you should go into to satisfy the target audience.

Some examples include, but is not limited to:

- New features in the Radius project that helps solve a particular problem 
    - Understanding and getting started with a particular feature, e.g., [Application graph blog post](https://blog.radapp.io/posts/2024/02/27/understand-your-entire-application-with-the-radius-application-graph/)
    - Technical deep dives into the feature, e.g., [Bicep blog post](https://blog.radapp.io/posts/2024/08/28/how-radius-leveraged-bicep-extensibility/)
- Customer case studies and success stories 
    - How customers are using Radius to solve their problems, e.g., [MBCP case study](https://blog.radapp.io/posts/2023/12/06/case-study-how-millennium-bcp-leverages-radius/)
    - Success stories of customers using Radius
- Comparison with other similar projects and how Radius is different
- Milestones and achievements of the Radius project, e.g., [Radius acceptance to CNCF as sandbox project](https://blog.radapp.io/posts/2024/04/16/radius-accepted-as-cloud-native-compute-foundation-cncf-sandbox-project/)
- Any problem that you solved in Radius that might be useful for others

### Blog Post Structure

- **Title**: The title should be clear, concise and should give a brief idea about the content of the blog post.

- **Introduction**: The introduction should give a brief overview of the topic that you are going to discuss in the blog post. It should be engaging and should make the reader want to read more. Assume you are talking to a reader who is completely new to the topic. Summarize the introduction in such a way that it is easy to understand the problem space for a beginner.

- **Subsections**: The blog post should be split into multiple sections to make it easier for the reader to navigate through the blog post. Each section should have a clear heading that gives an idea about the content of the section. The section headings themselves should tell a story and should be able to convey the message of the blog post.

- **Closing note**: The closing note should summarize the key points discussed in the blog post. It should also give a brief idea about what is expected of the reader next. It can be a call to action to check out Radius, get started on contributing to Radius or a suggestion to try out something in Radius. Here is an example [Learn More and Contribute](https://blog.radapp.io/posts/2024/02/27/understand-your-entire-application-with-the-radius-application-graph/#learn-more-and-contribute).

- **References**: If you are referring to any external sources, make sure to provide the references at the end of the blog post. This will help the reader to understand the context better and also to explore more about the topic.

### Writing Style 

- **Tone**: The tone of the blog post should be friendly and conversational. It should be easy to read and understand. Active voice is preferred over passive voice.

- **Language**: Language should be simple and easy to understand. 
    1. Always assume that the reader is new to Radius and the topic. Introduce Radius and the associated tools like Bicep and concepts in one or two sentences. Provide links to the documentation for the user to find more information about the topic.
    1. Avoid using jargon and technical terms that might be difficult for a beginner to understand. If you are using any technical terms, make sure to explain them in simple terms. 
    1. Avoid using phrases that are not open-source friendly. For example, instead of using "master" branch, use "main" branch and instead of using "team" refer to them as "community"
    1. Avoid using superlatives and exaggerations. Be honest and transparent in your writing.
    1. Use present tense. Avoid using `will` or `would` in the blog post.

- **Casing**: Capitalize the proper nouns, e.g. Radius, Bicep, Recipes. Use [sentence casing](https://apastyle.apa.org/style-grammar-guidelines/capitalization/sentence-case) for title and section headings.

- **Length**: The blog post should be concise and to the point. It should be readable within 3-5 minutes. For a technical blog, you can go deep into the details. Avoid long paragraphs and try to split the content into multiple sections.

- **Diagrams**: Add diagrams and visualizations wherever you can help the reader understand the content. This could be an architecture diagram, or a simple flow diagram that conveys the overall. If you are adding diagrams to the blog post, make sure to use the following `image` shortcode. 

    ```markdown
    {{< image src="<imagepath>" alt="<alt text>" width="750" >}}
    ```
    1. Diagrams should follow the same theme and color within the blog post. 
    1. Avoid blurry images and make sure the width of the image is set to 750px.
    1. You can use [Excalidraw](https://excalidraw.com/) tool to create diagrams. 

- **Code snippets**: If you are using code snippets in the blog post, make sure to use triple backticks ```<language> to wrap the code. This will help the reader to understand that it is a code snippet. 

    ```bash
    rad deploy app.bicep
    ```
 
- **Links**: If you are referring to any external sources, make sure to provide the links in the blog post. This will help the reader to explore more about the topic. Use the following format to add links in the blog post.

    ```markdown
    [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep)
