# image-manager/biggest-face-crop

# Use Case
This image manager policy automatically detects the biggest face in a picture and crops it to a size of 1000x1000. You can edit the json file to replace the size with whatever values you have.

## How to use the sample files

The sample files contain Image Manager policies in JSON format which you can just download and activate using the [Image Manager OPEN API](https://developer.akamai.com/api/luna/imaging/overview.html).

In order to interact with the Image Manager API, you need a set of OPEN API credentials with READ-WRITE access to the [Image Manager OPEN API](https://developer.akamai.com/api/luna/imaging/overview.html) (see the [Getting Started](https://developer.akamai.com/introduction/) documentation for information on setup API credentials). 

You also need to know the name of the Image Manager Policy Set (also known as "API Key" within the Property Manager's Image Manager behavior). For example in the property manager configuration for [developer.akamai.com](https://developer.akamai.com/), the Image Manager Policy Set is commanded "developer_akamai_com-4903103"; therefore all the Image Manager API commands that want to interact with that specific policy set will need to include the following HTTP Header: `Luna-Token:developer_akamai_com-4903103`

## Screenshots
* Image Manager Policy Manager: The Policy Manager looks like this: 
![screen 1](https://github.com/javiergarza/akamai-devops-library/blob/master/image-manager/biggest-face-crop/biggest-face-drop-01.png)
![screen 2](https://github.com/javiergarza/akamai-devops-library/blob/master/image-manager/biggest-face-crop//biggest-face-crop-02.png)
![screen 3](https://github.com/javiergarza/akamai-devops-library/blob/master/image-manager/biggest-face-crop//biggest-face-crop-03.png)


## Sample JSON IM policy Files

### [biggest-face-crop.json](biggest-face-crop.json)

Detects and crops the biggest face in the picture, converts the image to grayscale (black and white), and optimizes the resulting image applying "perceptualQuality"="mediumHigh" (which translates to great byte savings).

For example if my pristine image is [https://developer.akamai.com/image-manager/img/gallery-1.jpg](https://developer.akamai.com/image-manager/img/gallery-1.jpg) (a high quality stock image which is 7.14 MB), the resulting image of applying the `filter` policy: [https://developer.akamai.com/image-manager/img/gallery-1.jpg?impolicy=filter](https://developer.akamai.com/image-manager/img/gallery-1.jpg?impolicy=filter) would result on a black and white zoom of the person's face which is just 85.42 KB (almost 99% less bytes than the original), that is an amazing breakthrough your users are going to love.

## Piez

Piez is a Google Chrome extension that is very useful for debugging and estimating the value provided by Image Manager and a few other Akamai features. You can find Piez in the [Google Chrome Store](http://bit.ly/2LQbLpG)

## Image Manager sample API commands

In the examples below we use HTTPie (http), and it's edgegrid extension: a very useful CLI tool to explore APIs. Another tool mentioned below is jq, which is another CLI tool that will help us filter and format JSON. See [this Blog](http://bit.ly/2Odo1lA) for instructions on how to install and use HTTPie and jq

 
### List all Image Manager policies configured on the Policy Set "developer_akamai_com-4903103" (replace that with the right name for your policy set)
```
http --auth-type=edgegrid -a dac-imaging: :/imaging/v2/policies Luna-Token:developer_akamai_com-4903103
```  
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_ALL-policies.json)


### Let's add the "session" parameterm so we can simplify commands going forward
```
http --session=dacimg --auth-type=edgegrid -a dac-imaging: :/imaging/v2/policies Luna-Token:developer_akamai_com-4903103
```  
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_ALL-policies.json)


### Voila! We can now reference the session "dacimg" going forward and save some typing. Here is the same command as before: 
```
http --session=dacimg :/imaging/v2/policies 
```  
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_ALL-policies.json)


### Save all the policies into a file (in our example the file is commanded `dacimg_ALL-policies.json`)
```
http --session=dacimg :/imaging/v2/policies > dacimg_ALL-policies.json
```


### Filter the policy names 
```
http --session=dacimg :/imaging/v2/policies | jq .items[].id 
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_quoted-policy-names.txt)


### Filter the policy names and remove the double quotes 
```
http --session=dacimg :/imaging/v2/policies | jq .items[].id | sed 's/"//g'`
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_policy-names.txt)


### Loop through all the policy names and save each of them on a separate json file
This is the command I ran to generate all the json files I am including on this repository
```
for policy in `http --session=dacimg :/imaging/v2/policies | jq .items[].id | sed 's/"//g'`; do http --session=dacimg :/imaging/v2/policies/${policy} | jq . > dacimg_${policy}.json ; done
```

### Create a clone of the `conditional-orientation` policy called `conditional-orientation2` which rotates portrait images 90 degrees
```
sed 's/landscape/portrait/' dacimg_conditional-orientation.json > dacimg_conditional-orientation2.json
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_conditional-orientation2.json)


### Submit a new policy called conditional-orientation2 out of the json generated above
```
http --session=dacimg PUT :/imaging/v2/policies/conditional-orientation2 < dacimg_conditional-orientation2.json
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_conditional-orientation2_created.json)


### List all the policies and ensure the new policy is there
```
http --session=dacimg :/imaging/v2/policies | jq .items[].id
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_quoted-policy-names2.txt)


### Delete the newly created policy called conditional-orientation2
```
http --session=dacimg DELETE :/imaging/v2/policies/conditional-orientation2 
```
> See [OUTPUT](https://github.com/javiergarza/im-demo/tree/master/json/dacimg_conditional-orientation2_deleted.json)


