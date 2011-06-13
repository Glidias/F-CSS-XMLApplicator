package com.glidias.fcss.applicators 
{
	import com.flashartofwar.fcss.applicators.IApplicator;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	
	import com.flashartofwar.fcss.utils.TypeHelperUtil;
	
	import com.flashartofwar.fcss.objects.PropertyMapObject;
	import com.flashartofwar.fcss.utils.PropertyMapUtil; // BUG: this doesn't work for public variables!
	// Use sg-camo one instead..
	//import camo.core.utils.PropertyMapCache;
	
	/**
	 * Applies attributes and child node values to object
	 * @author Glenn Ko
	 */
	public class XMLApplicator implements IApplicator
	{
		public function XMLApplicator() {
			if (instance == null) {
				TypeHelperUtil.registerFunction("xml", function(str:String):XML { return XML(str) } );
			}
		}
		
		
		public function applyStyle (target:Object, style:Object) : void {
			var xml:XML = style as XML;  // try passive cast
			if (xml == null) {
				xml = XML(style); // try force cast
				if (xml == null) throw new Error("Cast to xml failed!:" +style); 
			}
			var propMap:Object =  PropertyMapUtil.propertyMap(target);// PropertyMapCache.getPropertyMap(target);
			var dataStr:String, prop:String;
			
			var xmlList:XMLList;
                        var len:int;
                        var i:int;

			// apply attributes (in any order??)
			xmlList = xml.attributes();
			len = xmlList.length();
			for (i= 0; i < len; i++) {
				dataStr  = xmlList[i];
				
				prop = xmlList[i].name().toString();
				//if (propMap[prop] != null) {
					target[prop] = TypeHelperUtil.getType(dataStr, propMap[prop]);
				//}
			}

            // apply nodes in order
            xmlList = xml.children(); 
			len = xmlList.length();
			for (i= 0; i < len; i++) {
				dataStr  = xmlList[i];
				
				prop = xmlList[i].name().toString();
				//if (propMap[prop] != null) {
					target[prop] = TypeHelperUtil.getType(dataStr, propMap[prop]);
				//}
			}
			
		}
		
		public static const instance:XMLApplicator = new XMLApplicator();
		
		public static function registerSerializable(classe:Class, factoryMethod:Function=null, vectorFixed:Boolean=false):void 
		{
			var ider:String = getQualifiedClassName(classe).toLowerCase();
			TypeHelperUtil.registerFunction(ider , 
			function(xmlStr:String):* {
				var xml:XML = XML(xmlStr);
				var classeInstance:* = factoryMethod == null ? new classe() : factoryMethod();
				instance.applyStyle(classeInstance, xml);
				return classeInstance;
			} );
			
			var vecClasse:Class = getDefinitionByName("__AS3__.vec::Vector.<" + getQualifiedClassName(classe) + ">") as Class;
			TypeHelperUtil.registerFunction("__as3__.vec::vector.<" + ider + ">",
			function(xmlStr:String):* {
				var xml:XML = XML(xmlStr);
				var xmlList:XMLList = xml.children();
				var len:int = xmlList.length();
				var classeVec:* = new vecClasse();
				for (var i:int = 0; i < len; i++ ) {
					var classeInstance:* = factoryMethod == null ? new classe() : factoryMethod();
					instance.applyStyle(classeInstance, xmlList[i]);
					classeVec.push(classeInstance);
					//classeVec[i] = classeInstance;
				}
				classeVec.fixed = vectorFixed;
				return classeVec;
			}
			);
		}
		
		public static function getXMLOfVec(nodeName:String, vec:*):XML {
			var xml:XML = <{nodeName} />;
			var len:int = vec.length;
			for (var i:int = 0; i < len; i++) {
				if (!(vec[i] is IXMLSerializable)) {
					throw new Error("FAILED:!"+vec[i] + " isn't IXMLSerializable!");
				}
				xml.appendChild( (vec[i] as IXMLSerializable).getXML() );
			}
			return xml;
		}
		
	}
	
	

}