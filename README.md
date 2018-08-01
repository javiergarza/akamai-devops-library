# akamai-devops-library
Sample code and procedures to help configuring Akamai services quickly, and repeatedly. 

To contribute to the library you need to share three files into a github subrepo under https://github.com/akamai/akamai-devops-library.git: 

* A readme text file [(see sample template template_README.md)](./template_README.md)
* A screenshot(s) showing how to implement the functionality using the Property Manager UI [(see sample image redirect-to-dir-with-slash.png)](./redirect-to-dir-with-slash.png)
* A JSON file showing the code people need to use to implement the functionality via the Akamai CLI “property” module like:
```
akamai property update <property> --file <rules.json>
```
[(see sample code redirect-to-dir-with-slash.json)](./redirect-to-dir-with-slash.json)
