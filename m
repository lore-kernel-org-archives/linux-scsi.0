From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: [linux-usb-devel] usb-storage and Sony Handycam
Date: Sun,  9 Nov 2003 19:45:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068367546.3fadfebaf39b5@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311082220430.7127-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail.netregistry.net ([203.202.16.21]:7055 "EHLO
	webmail.netregistry.net") by vger.kernel.org with ESMTP
	id S262197AbTKIIqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2003 03:46:08 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311082220430.7127-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Idan Sofer <idan@idanso.dyndns.org>, "ronald@kuetemeier.com" <ronald@kuetemeier.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

[My previous msg didn't make it to the list, resending]

Attached here for your perusal is USB log for this device on win98.

Regards,
Dmitri


1	in down	n/a	0.062	GET_DESCRIPTOR_FROM_DEVICE		
URB Header (length: 80)
SequenceNumber: 1
Function: 000b (GET_DESCRIPTOR_FROM_DEVICE)
1	in up	n/a	0.066	CONTROL_TRANSFER	12 01 00 01 00 00 00 08
	0x00000000
URB Header (length: 80)
SequenceNumber: 1
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 80 06 00 01 00 00 12 00 
bmRequestType: 80
  DIR: Device-To-Host
  TYPE: Standard
  RECIPIENT: Device
bRequest: 06  
  GET_DESCRIPTOR
Descriptor Type: 0x0001
  DEVICE


TransferBuffer: 0x00000012 (18) length
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
2	in down	n/a	0.066	GET_DESCRIPTOR_FROM_DEVICE		
URB Header (length: 80)
SequenceNumber: 2
Function: 000b (GET_DESCRIPTOR_FROM_DEVICE)
2	in up	n/a	0.076	CONTROL_TRANSFER	09 02 27 00 01 01 00 40
	0x00000000
URB Header (length: 80)
SequenceNumber: 2
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 80 06 00 02 00 00 09 02 
bmRequestType: 80
  DIR: Device-To-Host
  TYPE: Standard
  RECIPIENT: Device
bRequest: 06  
  GET_DESCRIPTOR
Descriptor Type: 0x0002
  CONFIGURATION


TransferBuffer: 0x00000027 (39) length
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
3	??? down	n/a	0.076	SELECT_CONFIGURATION		
URB Header (length: 100)
SequenceNumber: 3
Function: 0000 (SELECT_CONFIGURATION)
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
3	??? up	n/a	0.076	SELECT_CONFIGURATION		0x00000000
URB Header (length: 100)
SequenceNumber: 3
Function: 0000 (SELECT_CONFIGURATION)
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
4	out down	n/a	3.142	CLASS_INTERFACE	12 00 00 00 24 00 00 00	
URB Header (length: 80)
SequenceNumber: 4
Function: 001b (CLASS_INTERFACE)
PipeHandle: c146f640

SetupPacket:
0000: 21 00 00 00 00 00 00 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


TransferBuffer: 0x0000000c (12) length
0000: 12 00 00 00 24 00 00 00 00 00 00 00 
4	out up	n/a	3.146	CONTROL_TRANSFER	-	0x00000000
URB Header (length: 80)
SequenceNumber: 4
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


No TransferBuffer

5	in down	0x82	3.146	BULK_OR_INTERRUPT_TRANSFER	-	
URB Header (length: 72)
SequenceNumber: 5
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

No TransferBuffer

5	in up	0x82	3.146	BULK_OR_INTERRUPT_TRANSFER	00 80 00 01 1f 
00 00 00	0x00000000
URB Header (length: 72)
SequenceNumber: 5
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

TransferBuffer: 0x00000024 (36) length
0000: 00 80 00 01 1f 00 00 00 53 6f 6e 79 20 20 20 20 
0010: 53 6f 6e 79 20 44 53 43 20 20 20 20 20 20 20 20 
0020: 33 2e 30 30 
6	in down	0x82	3.146	CLASS_INTERFACE	25 00 00 00 00 00 00 00	
URB Header (length: 80)
SequenceNumber: 6
Function: 001b (CLASS_INTERFACE)
PipeHandle: c156772c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


TransferBuffer: 0x0000000c (12) length
0000: 25 00 00 00 00 00 00 00 00 00 00 00 
6	out up	n/a	3.152	CONTROL_TRANSFER	-	0x00000000
URB Header (length: 80)
SequenceNumber: 6
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


No TransferBuffer

7	in down	0x82	3.152	BULK_OR_INTERRUPT_TRANSFER	-	
URB Header (length: 72)
SequenceNumber: 7
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

No TransferBuffer

7	in up	0x82	3.156	BULK_OR_INTERRUPT_TRANSFER	00 00 1e df 00 
00 02 00	0x00000000
URB Header (length: 72)
SequenceNumber: 7
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

TransferBuffer: 0x00000008 (8) length
0000: 00 00 1e df 00 00 02 00 
8	in down	0x82	3.166	CLASS_INTERFACE	00 00 00 00 00 00 00 00	
URB Header (length: 80)
SequenceNumber: 8
Function: 001b (CLASS_INTERFACE)
PipeHandle: c156772c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


TransferBuffer: 0x0000000c (12) length
0000: 00 00 00 00 00 00 00 00 00 00 00 00 
8	out up	n/a	3.171	CONTROL_TRANSFER	-	0x00000000
URB Header (length: 80)
SequenceNumber: 8
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


No TransferBuffer

9	out down	n/a	3.172	CLASS_INTERFACE	25 00 00 00 00 00 00 00	
URB Header (length: 80)
SequenceNumber: 9
Function: 001b (CLASS_INTERFACE)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


TransferBuffer: 0x0000000c (12) length
0000: 25 00 00 00 00 00 00 00 00 00 00 00 
9	out up	n/a	3.176	CONTROL_TRANSFER	-	0x00000000
URB Header (length: 80)
SequenceNumber: 9
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


No TransferBuffer

10	in down	0x82	3.181	BULK_OR_INTERRUPT_TRANSFER	-	
URB Header (length: 72)
SequenceNumber: 10
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

No TransferBuffer

10	in up	0x82	3.182	BULK_OR_INTERRUPT_TRANSFER	00 00 1e df 00 
00 02 00	0x00000000
URB Header (length: 72)
SequenceNumber: 10
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

TransferBuffer: 0x00000008 (8) length
0000: 00 00 1e df 00 00 02 00 
11	in down	0x82	3.191	CLASS_INTERFACE	28 00 00 00 00 00 00 00	
URB Header (length: 80)
SequenceNumber: 11
Function: 001b (CLASS_INTERFACE)
PipeHandle: c156772c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


TransferBuffer: 0x0000000c (12) length
0000: 28 00 00 00 00 00 00 00 80 00 00 00 
11	out up	n/a	3.196	CONTROL_TRANSFER	-	0x00000000
URB Header (length: 80)
SequenceNumber: 11
Function: 0008 (CONTROL_TRANSFER)
PipeHandle: c1565d8c

SetupPacket:
0000: 21 00 00 00 00 00 0c 00 
bmRequestType: 21
  DIR: Host-To-Device
  TYPE: Class
  RECIPIENT: Interface
bRequest: 00  


No TransferBuffer

12	in down	0x82	3.201	BULK_OR_INTERRUPT_TRANSFER	-	
URB Header (length: 72)
SequenceNumber: 12
Function: 0009 (BULK_OR_INTERRUPT_TRANSFER)
TransferFlags: 0x00000003

No TransferBuffer


