package com.tiltdigital.swiz.beans.loader.model.loaders{	import flash.geom.Rectangle;	import flash.utils.ByteArray;	import flash.utils.Endian;		/**	 * @author Jamie.Hill	 */	public class SwfByteArray extends ByteArray	{	    private static const TAG_SWF	     			: String = "FWS";	    private static const TAG_SWF_COMPRESSED			: String = "CWS";	    	    public var frameRate							: Number;	    public var bitIndex								: uint;	    public var rect									: Rectangle;	    public var version								: uint;	    	    public function SwfByteArray( data:ByteArray=null )	    {	        super();	        	        super.endian = Endian.LITTLE_ENDIAN;	        	        var endian:String, tag:String;	        	        if( data )	        {	            endian 		= data.endian;	            data.endian = Endian.LITTLE_ENDIAN;	            	            if ( data.bytesAvailable > 26 )	            {	                tag = data.readUTFBytes( 3 );	                	                if( tag == SwfByteArray.TAG_SWF || tag == SwfByteArray.TAG_SWF_COMPRESSED )	                {	                    version = data.readUnsignedByte();	                    data.readUnsignedInt();	                    data.readBytes(this);	                    if (tag == SwfByteArray.TAG_SWF_COMPRESSED) super.uncompress();	                } else throw new ArgumentError('Error #2124: Loaded file is an unknown type.');	                	                this.readHeader();	            }	            	            data.endian = endian;	        }	    }	    	    		    public function writeBytesFromString( bytesHexString:String ) : void	    {	        var length:uint = bytesHexString.length;	        	        for( var i:uint = 0;i<length;i += 2 )	        {	            var hexByte:String = bytesHexString.substr( i, 2 );	            var byte:uint = parseInt(hexByte, 16);	            writeByte(byte);	        }	    }	    	    public function readRect():Rectangle	    {	        var pos:uint = super.position;	        var byte:uint = this[pos];	        var bits:uint = byte >> 3;	        var xMin:Number = this.readBits(bits, 5) / 20;	        var xMax:Number = this.readBits(bits) / 20;	        var yMin:Number = this.readBits(bits) / 20;	        var yMax:Number = this.readBits(bits) / 20;	        super.position = pos + Math.ceil(((bits * 4) - 3) / 8) + 1;	        return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);	    }	    	    public function readBits(length:uint, start:int = -1) : Number	    {	        if (start < 0) start = bitIndex;	        bitIndex = start;	        var byte:uint = this[super.position];	        var out:Number = 0;	        var shift:Number = 0;	        var currentByteBitsLeft:uint = 8 - start;	        var bitsLeft:Number = length - currentByteBitsLeft;	        	        if (bitsLeft > 0) {	            super.position++;	            out = this.readBits(bitsLeft, 0) | ((byte & ((1 << currentByteBitsLeft) - 1)) << (bitsLeft));	        } else {	            out = (byte >> (8 - length - start)) & ((1 << length) - 1);	            bitIndex = (start + length) % 8;	            if (start + length > 7) super.position++;	        }	        return out;	    }	    			    /**	     * @private	     */	    private function readFrameRate() : void	    {	        if( version < 8 )	        {	            frameRate = super.readUnsignedShort();	        } else	        {	            var fixed:Number	= super.readUnsignedByte() / 0xFF;	            frameRate			= super.readUnsignedByte() + fixed;	        }	    }	    	    /**	     * @private	     */	    private function readHeader() : void	    {	        rect = this.readRect();	        readFrameRate();     	           	        super.readShort();	    }	}}