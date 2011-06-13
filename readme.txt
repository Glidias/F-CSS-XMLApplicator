How to use?
-------

It's only 1 class file and 1 interface in the package. It's that simple! We assume you're already familiar with the property application system used in F-CSS at http://fcss.flashartofwar.com/ . However, rather than use CSS stylesheets to apply properties, we use the basic property application system in F-CSS to simply apply properties through basic XML markup (or even spawn new ones).

Assuming "object" is an XML, the code:

XMLApplicator.instance.applyStyle(target, object);

is used to apply the object xml's attributes and children nodes as properties onto the "target".

___________

But wait, there's more! You can register a typed class, (and optionally with) a factory method, to spawn a given typed entity during property application! It even registers Vector types for the given class so you can also fill a given Vector.<Type> public variable/setter with multiple entities when applyStyle() is used!

I'll document more (with example)
on the:
XMLApplicator.instance.registerSerializable(class:Class, factoryMethod:Function=null, vectorFixed:Boolean=false)  method later. WHat it does is it provides a very fast way for registering your own custom object types so that they can easily be applied on any given public property of a targetted object when applyStyle() is used afterwards. In short, it allows for fast-spawning of objects that are immediately assigned to typed variables/setters (whether ":Type" or ":Vector.<Type>"), in a blink of an eye.

And a handy method 
XMLApplicator.instance.getXMLOfVec(nodeName:String, vec:*):XML to return an xml consisting of multiple child nodes, where each child node represents an IXMLSerializable instance.

IXMLSerializable.getXML():XML allows one to define the XML template format for outputting it's XML settings . This allows for quick saving/re-loading of data.