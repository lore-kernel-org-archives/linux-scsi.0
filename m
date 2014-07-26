From: "Laszlo T." <tlacix@gmail.com>
Subject: Re: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Sat, 26 Jul 2014 21:59:28 +0200
Message-ID: <CAOaU5MZxg4eFsFO51fkCqx_HLAi=TcZKqdJ8RAOL4F+iU50RkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44828 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaGZT73 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 15:59:29 -0400
Received: by mail-ig0-f177.google.com with SMTP id hn18so2119248igb.10
        for <linux-scsi@vger.kernel.org>; Sat, 26 Jul 2014 12:59:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stern@rowland.harvard.edu

Hello,

First of all I've just subscribed the linux-scsi thread. I hope you
get my email the right way.

I have also problems with Jmicron JMS567 mobile rack.

I tried on different kernels:
3.15.5
3.16.rc6
the 'Invalid field in cdb' errors disappeared but still not ok.

I got the following errors when I ran a mkfs.ext4 command and then the
device disappeared.

Jul 26 19:54:37 debian kernel: [  118.060026] usb 8-3: new high-speed
USB device number 2 using ehci-pci
Jul 26 19:54:37 debian kernel: [  118.245208] usb 8-3: New USB device
found, idVendor=152d, idProduct=0567
Jul 26 19:54:37 debian kernel: [  118.245210] usb 8-3: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Jul 26 19:54:37 debian kernel: [  118.245212] usb 8-3: Product: USB to
ATA/ATAPI Bridge
Jul 26 19:54:37 debian kernel: [  118.245213] usb 8-3: Manufacturer: JMicron
Jul 26 19:54:37 debian kernel: [  118.245215] usb 8-3: SerialNumber:
74D781114413108
Jul 26 19:54:37 debian mtp-probe: checking bus 8, device 2:
"/sys/devices/pci0000:00/0000:00:1d.7/usb8/8-3"
Jul 26 19:54:37 debian mtp-probe: bus: 8, device: 2 was not an MTP device
Jul 26 19:54:37 debian kernel: [  118.257932] usbcore: registered new
interface driver usb-storage
Jul 26 19:54:37 debian kernel: [  118.259053] scsi6 : uas
Jul 26 19:54:37 debian kernel: [  118.259178] usbcore: registered new
interface driver uas
Jul 26 19:54:37 debian kernel: [  118.259720] scsi 6:0:0:0:
Direct-Access     JMicron  Generic          0114 PQ: 0 ANSI: 6
Jul 26 19:54:37 debian kernel: [  118.260863] sd 6:0:0:0: Attached
scsi generic sg2 type 0
Jul 26 19:54:37 debian kernel: [  118.261217] sd 6:0:0:0: [sdc]
Spinning up disk...
Jul 26 19:54:39 debian kernel: [  119.264049] ..ready
Jul 26 19:54:39 debian kernel: [  120.268470] sd 6:0:0:0: [sdc]
976773168 512-byte logical blocks: (500 GB/465 GiB)
Jul 26 19:54:39 debian kernel: [  120.268472] sd 6:0:0:0: [sdc]
4096-byte physical blocks
Jul 26 19:54:39 debian kernel: [  120.269468] sd 6:0:0:0: [sdc] Write
Protect is off
Jul 26 19:54:39 debian kernel: [  120.269968] sd 6:0:0:0: [sdc] Write
cache: enabled, read cache: enabled, supports DPO and FUA
Jul 26 19:54:39 debian kernel: [  120.290104]  sdc: sdc1 sdc2
Jul 26 19:54:39 debian kernel: [  120.292356] sd 6:0:0:0: [sdc]
Attached SCSI disk
Jul 26 19:56:15 debian kernel: [  216.611696] usb 8-3: USB disconnect,
device number 2
Jul 26 19:56:15 debian kernel: [  216.611697] sd 6:0:0:0: [sdc]
uas_submit_sense_urb ffff8800ca32ac80 tag 112, inflight: s-st a-out
a-cmd s-cmd
Jul 26 19:56:15 debian kernel: [  216.611700] scsi host6: sense urb
submission error -19 stream 0
Jul 26 19:56:15 debian kernel: [  216.612035] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca2f2240 tag 39, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612120] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca2f20c0 tag 40, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612185] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300dc0 tag 41, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612248] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300c40 tag 42, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612315] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300ac0 tag 43, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612377] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300940 tag 44, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612441] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca3007c0 tag 45, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612504] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300640 tag 46, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612570] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca3004c0 tag 47, inflight: CMD
Jul 26 19:56:15 debian kernel: [  216.612633] sd 6:0:0:0: [sdc]
uas_cmd_cmplt ffff8800ca300340 tag 48, inflight: CMD
...
Jul 26 19:56:15 debian kernel: [  216.625366] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca3277c0 tag 105, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625368] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625370] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca327640 tag 106, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625371] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625373] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca3274c0 tag 107, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625375] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625377] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca327340 tag 108, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625378] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625380] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca3271c0 tag 109, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625382] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625384] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca327040 tag 110, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625385] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625387] sd 6:0:0:0: [sdc]
uas_zap_dead ffff8800ca32ae00 tag 111, inflight: CMD abort
Jul 26 19:56:15 debian kernel: [  216.625389] sd 6:0:0:0: [sdc] abort completed
Jul 26 19:56:15 debian kernel: [  216.625412] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.625414] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.625416] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.625417] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.625419] Write(10): 2a 00 00 04
08 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.625555] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.625622] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.625698] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.625790] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.625950] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626013] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626077] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626140] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626204] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626268] lost page write due to
I/O error on sdc2
Jul 26 19:56:15 debian kernel: [  216.626659] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.626662] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.626662] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.626663] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.626664] Write(10): 2a 00 00 04
0c 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.626790] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.626792] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.626793] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.626794] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.626795] Write(10): 2a 00 00 04
10 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.626924] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.626925] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.626926] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.626928] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.626928] Write(10): 2a 00 00 04
14 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.627059] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.627061] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.627062] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.627063] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.627064] Write(10): 2a 00 00 04
18 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.627195] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.627196] sd 6:0:0:0: [sdc]
Jul 26 19:56:15 debian kernel: [  216.627197] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jul 26 19:56:15 debian kernel: [  216.627199] sd 6:0:0:0: [sdc] CDB:
Jul 26 19:56:15 debian kernel: [  216.627199] Write(10): 2a 00 00 04
1c 00 00 04 00 00
Jul 26 19:56:15 debian kernel: [  216.627327] sd 6:0:0:0: [sdc]
Unhandled error code
Jul 26 19:56:15 debian kernel: [  216.627328] sd 6:0:0:0: [sdc]



lsusb:

Bus 008 Device 002: ID 152d:0567 JMicron Technology Corp. / JMicron
USA Technology Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x152d JMicron Technology Corp. / JMicron USA
Technology Corp.
  idProduct          0x0567
  bcdDevice            1.14
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           85
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4
    bmAttributes         0xc0
      Self Powered
    MaxPower               30mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              6
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     98
      iInterface             10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
        Command pipe (0x01)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
        Status pipe (0x02)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
        Data-in pipe (0x03)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
        Data-out pipe (0x04)

What can the problem be?

Thanks,
Laszlo
