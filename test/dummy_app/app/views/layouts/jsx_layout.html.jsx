import {createElement} from 'complate-stream';

export default ({content}) => <html>
  <head>
    <title>Dummy with JSX based layout</title>
    {rails.csrf_meta_tags()}

    {rails.stylesheet_link_tag('application', { 'media': 'all', 'data-turbolinks-track': 'reload' })}
    {rails.javascript_include_tag('application', { 'data-turbolinks-track': 'reload' })}
  </head>

  <body>
    {content}
  </body>
</html>
