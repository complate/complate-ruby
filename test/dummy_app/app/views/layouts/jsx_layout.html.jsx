import {createElement, safe} from 'complate-stream';

export default ({content}) => <html>
  <head>
    <title>Dummy with JSX based layout</title>
    {/*rails.csrf_meta_tags()*/}

    {safe(rails.stylesheet_link_tag('application', { 'media': 'all', 'data-turbolinks-track': 'reload' }))}
    {safe(rails.javascript_include_tag('application', { 'data-turbolinks-track': 'reload' }))}
  </head>

  <body>
    {safe(content)}
  </body>
</html>
