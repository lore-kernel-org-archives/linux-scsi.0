From: Andries.Brouwer@cwi.nl
Subject: Re: usb-storage and Sony Handycam
Date: Mon, 10 Nov 2003 23:21:42 +0100 (MET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <UTC200311102221.hAAMLgV04712.aeb@smtp.cwi.nl>
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: dmitrik@users.sourceforge.net, patmans@us.ibm.com
Cc: idan@idanso.dyndns.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, ronald@kuetemeier.com, stern@rowland.harvard.edu
List-Id: linux-scsi@vger.kernel.org

    Can someone verify my decoding? (This matches what Dmitri sent earlier
    that did not make it to the list, execept it looks like it starts with an
    INQUIRY VPD page 0 - get a list of supported VPD pages).

No, that is not a SCSI command.

    > TransferBuffer: 0x00000012 (18) length
    > 0000: 12 01 00 01 00 00 00 08 4c 05 2e 00 00 03 01 02 
    > 0010: 00 01 

The meaning is decoded below.

    >     bLength            : 0x12 (18)
    >     bDescriptorType    : 0x01 (1)
    >     bcdUSB             : 0x0100 (256)
    >     bDeviceClass       : 0x00 (0)
    >     bDeviceSubClass    : 0x00 (0)
    >     bDeviceProtocol    : 0x00 (0)
    >     bMaxPacketSize0    : 0x08 (8)
    >     idVendor           : 0x054c (1356)
    >     idProduct          : 0x002e (46)
    >     bcdDevice          : 0x0300 (768)
    >     iManufacturer      : 0x01 (1)
    >     iProduct           : 0x02 (2)
    >     iSerialNumber      : 0x00 (0)
    >     bNumConfigurations : 0x01 (1)

It is the device that reports that it is 054c:002e
a Sony HandyCam MemoryStick Reader.


-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
