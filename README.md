# akamai-devops-library
Sample code to easily allow configuring Akamai services

Anybody can contribute to the Akamai DevOps library by just sharing 3 files into a github subrepo under https://github.com/akamai/akamai-devops-library.git: 

* A readme text file [(see sample template template_README.md)](./template_README.md)
* A screenshot(s) showing how to implement the functionality using the Graphical User Interface in the Akamai Console https://control.akamai.com [(see sample image redirect-to-dir-with-slash.png)](./redirect-to-dir-with-slash.png)
* A JSON file showing the code people need to use to implement the functionality by using a Command Line Interface client like [HTTPie](https://httpie.org/) or the [Akamai CLI](https://developer.akamai.com/cli/):

For example if you provide a snippet file called "rules.json" to configure a given functionality usining the Property Manager API you would run a command like this on the Akamai cli:
 ```
akamai property update <property> --file <rules.json>
```
[(see sample code redirect-to-dir-with-slash.json)](./redirect-to-dir-with-slash.json)
