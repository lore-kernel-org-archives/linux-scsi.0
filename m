From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: usb-storage and Sony Handycam
Date: Sun,  9 Nov 2003 00:29:02 +1100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1068298142.3facef9eda01a@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311071448200.10810-100000@ida.rowland.org> <1068260051.3fac5ad3ea76c@webmail.netregistry.net> <20031107223444.A1747@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20031107223444.A1747@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "linux-usb-devel@lists.sourceforge.net" <linux-usb-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Quoting Patrick Mansfield <patmans@us.ibm.com>:

> We need to figure out what is different here, and why (based on other
> reports for this device) this worked on 2.4 but not on 2.6.

USB log from "the other" OS is attached for your perusal.
I've compressed and parsed it a little. From what I see the device 
is anything but compliant, but then it does not claim to be.


Regards,
Dmitri

GET_DESCRIPTOR_FROM_DEVICE		
Descriptor Type: 0x0001 DEVICE
0000: 12 01 00 01 00 00 00 08 4c 05 2e 00 00 03 01 02 
0010: 00 01 
    bLength            : 0x12 (18)
    bDescriptorType    : 0x01 (1)
    bcdUSB             : 0x0100 (256)
    bDeviceClass       : 0x00 (0)
    bDeviceSubClass    : 0x00 (0)
    bDeviceProtocol    : 0x00 (0)
    bMaxPacketSize0    : 0x08 (8)
    idVendor           : 0x054c (1356)
    idProduct          : 0x002e (46)
    bcdDevice          : 0x0300 (768)
    iManufacturer      : 0x01 (1)
    iProduct           : 0x02 (2)
    iSerialNumber      : 0x00 (0)
    bNumConfigurations : 0x01 (1)


GET_DESCRIPTOR_FROM_DEVICE		
Descriptor Type: 0x0002   CONFIGURATION
0000: 09 02 27 00 01 01 00 40 01 09 04 00 00 03 08 ff 
0010: 01 00 07 05 01 02 40 00 00 07 05 82 02 40 00 00 
0020: 07 05 83 03 08 00 ff 
    bLength            : 0x09 (9)
    bDescriptorType    : 0x02 (2)
    wTotalLength       : 0x0027 (39)
    bNumInterfaces     : 0x01 (1)
    bConfigurationValue: 0x01 (1)
    iConfiguration     : 0x00 (0)
    bmAttributes       : 0x40 (64)
    MaxPower           : 0x01 (1)

SELECT_CONFIGURATION		
Configuration Descriptor:
bLength: 9 (0x09)
bDescriptorType: 2 (0x02)
wTotalLength: 39 (0x0027)
bNumInterfaces: 1 (0x01)
bConfigurationValue: 1 (0x01)
iConfiguration: 0 (0x00)
bmAttributes: 64 (0x40)
  0x40: Self Powered
MaxPower: 1 (0x01)
  (in 2 mA units, therefore 2 mA power consumption)

Number of interfaces: 1
Interface[0]:
  Length: 0x004c
  InterfaceNumber: 0x00
  AlternateSetting: 0x00
  Class             = 0x34
  SubClass          = 0x6d
  Protocol          = 0x37
  InterfaceHandle   = 0x00000000
  NumberOfPipes     = 0x00000003
  Pipe[0]:
    MaximumPacketSize = 0xaff0
    EndpointAddress   = 0x4b
    Interval          = 0xc1
    PipeType          = 0x00
      UsbdPipeTypeControl
    PipeHandle        = 0x0000ce54
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00
  Pipe[1]:
    MaximumPacketSize = 0x2f68
    EndpointAddress   = 0x5b
    Interval          = 0xbc
    PipeType          = 0x206a2b1b
      !!! INVALID !!!
    PipeHandle        = 0x4e4f5300
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00
  Pipe[2]:
    MaximumPacketSize = 0x000d
    EndpointAddress   = 0x00
    Interval          = 0x00
    PipeType          = 0xc15667d0
      !!! INVALID !!!
    PipeHandle        = 0xc1566810
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00

SELECT_CONFIGURATION
Configuration Descriptor:
bLength: 9 (0x09)
bDescriptorType: 2 (0x02)
wTotalLength: 39 (0x0027)
bNumInterfaces: 1 (0x01)
bConfigurationValue: 1 (0x01)
iConfiguration: 0 (0x00)
bmAttributes: 64 (0x40)
  0x40: Self Powered
MaxPower: 1 (0x01)
  (in 2 mA units, therefore 2 mA power consumption)

Number of interfaces: 1
Interface[0]:
  Length: 0x004c
  InterfaceNumber: 0x00
  AlternateSetting: 0x00
  Class             = 0x08
  SubClass          = 0xff
  Protocol          = 0x01
  InterfaceHandle   = 0xc1567700
  NumberOfPipes     = 0x00000003
  Pipe[0]:
    MaximumPacketSize = 0x0040
    EndpointAddress   = 0x01
    Interval          = 0x00
    PipeType          = 0x02
      UsbdPipeTypeBulk
    PipeHandle        = 0xc1567718
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00
  Pipe[1]:
    MaximumPacketSize = 0x0040
    EndpointAddress   = 0x82
    Interval          = 0x00
    PipeType          = 0x02
      UsbdPipeTypeBulk
    PipeHandle        = 0xc156772c
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00
  Pipe[2]:
    MaximumPacketSize = 0x0008
    EndpointAddress   = 0x83
    Interval          = 0xff
    PipeType          = 0x03
      UsbdPipeTypeInterrupt
    PipeHandle        = 0xc1567740
    MaxTransferSize   = 0x00010000
    PipeFlags         = 0x00

---------------------------------------------
out 0c (12) length
0000: 12 00 00 00 24 00 00 00 00 00 00 00       INQUIRY

in 0x00000024 (36) length                       
0000: 00 80 00 01 1f 00 00 00 53 6f 6e 79 20 20 20 20 
0010: 53 6f 6e 79 20 44 53 43 20 20 20 20 20 20 20 20 
0020: 33 2e 30 30 

out 0x0000000c (12) length
0000: 25 00 00 00 00 00 00 00 00 00 00 00       READ CAPACITY

in 0x00000008 (8) length
0000: 00 00 1e df 00 00 02 00                   7903 blocks x 512 = 4,046,366 
bytes

out 0x0000000c (12) length
0000: 00 00 00 00 00 00 00 00 00 00 00 00       TEST UNIT READY

out 0x0000000c (12) length
0000: 25 00 00 00 00 00 00 00 00 00 00 00       READ CAPACITY

in 0x00000008 (8) length
0000: 00 00 1e df 00 00 02 00                   7903 blocks x 512 = 4,046,366 
bytes

out 0x0000000c (12) length
0000: 28 00 00 00 00 00 00 00 80 00 00 00       READ 128 blocks, starting from 0

<end of log>





-------------------------------------------------------
This SF.Net email sponsored by: ApacheCon 2003,
16-19 November in Las Vegas. Learn firsthand the latest
developments in Apache, PHP, Perl, XML, Java, MySQL,
WebDAV, and more! http://www.apachecon.com/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
