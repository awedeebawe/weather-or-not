# Weather-or-not

Weather-or-not is simply a weather client.

#### What is included:

  - XCode project *last built with **Version 9.2 beta** (9C34b)*
  - **csv-generator** (to avoid the manual csv file creation by randomizing the temperature values)

> the **csv-generator** can be run as a
> **[standalone app]** through the command line.
> But to make the process seamless the whole csv file 
> setup is added as a build phase before the Bundle Resource Copy phase.

#### Dev note:

> the csv-generator generates values from tomorrow up to 4 days after tomorrow, ignoring today` 


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [standalone app]: <https://github.com/awedeebawe/weather-or-not/tree/master/csv-generator>
