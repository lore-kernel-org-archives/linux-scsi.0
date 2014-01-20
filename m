From: =?utf-8?q?Milan_Svoboda?= <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
Subject: =?utf-8?q?Re=3A_usb_disk_recognized_but_fails?=
Date: Mon, 20 Jan 2014 20:00:23 +0100
Message-ID: <20140120200023.5F31B6AF@centrum.cz>
References: <20140115154739.7DC8AFD8@centrum.cz> <20140120182319.GB5545@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140120182319.GB5545@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?utf-8?q?USB_Storage_List?= <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Non-working:

3.12.7-2-ARCH #1 SMP PREEMPT Sun Jan 12 13:09:09 CET 2014 x86_64 GNU/Li=
nux

I'm sorry, I don't remember exactly which version worked, I have had th=
e disk connected to TV for
a long time and only recently I wanted to copy some movies on it. I gue=
ss it worked something like
6 or 9 months ago.

Milan

______________________________________________________________
> Od: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Komu: Milan Svoboda <milan.svoboda-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
> Datum: 20.01.2014 19:23
> P=C5=99edm=C4=9Bt: Re: usb disk recognized but fails
>
> CC: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "USB Storage List" <usb-storage@lists.=
one-eyed-alien.net>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Cc-ing the USB storage list, in case this device needs some quirk.
>
>On Wed, Jan 15, 2014 at 03:47:39PM +0100, Milan Svoboda wrote:
>> The SATA adapter has a power input, but it is not used, it is connec=
ted to the
>> PC with Y-type USB cable.
>>=20
>> The disk works with my "smart" TV, it works with Windows on the same=
 machine,
>> it also had worked some time ago with Linux, but now it shows the fo=
llowing:
>
>Do you know which kernel version it worked with?  What version are you
>currently running?  Please run `uname -a`.
>
>> [ 2192.027213] usb 1-3: new high-speed USB device number 5 using xhc=
i_hcd
>> [ 2192.042323] ums-cypress 1-3:1.0: USB Mass Storage device detected
>> [ 2192.042500] scsi9 : usb-storage 1-3:1.0
>> [ 2193.044219] scsi 9:0:0:0: Direct-Access     WDC WD64 00BPVT-00HXZ=
T0        PQ: 0 ANSI: 0
>> [ 2193.045083] sd 9:0:0:0: [sdb] 1250263728 512-byte logical blocks:=
 (640 GB/596 GiB)
>> [ 2193.045240] sd 9:0:0:0: [sdb] Write Protect is off
>> [ 2193.045245] sd 9:0:0:0: [sdb] Mode Sense: 03 00 00 00
>> [ 2193.045384] sd 9:0:0:0: [sdb] No Caching mode page found
>> [ 2193.045388] sd 9:0:0:0: [sdb] Assuming drive cache: write through
>> [ 2193.046259] sd 9:0:0:0: [sdb] No Caching mode page found
>> [ 2193.046264] sd 9:0:0:0: [sdb] Assuming drive cache: write through
>> [ 2193.054389]  sdb: sdb1
>> [ 2193.055092] sd 9:0:0:0: [sdb] No Caching mode page found
>> [ 2193.055095] sd 9:0:0:0: [sdb] Assuming drive cache: write through
>> [ 2193.055098] sd 9:0:0:0: [sdb] Attached SCSI disk
>> [ 2200.821345] usb 1-3: reset high-speed USB device number 5 using x=
hci_hcd
>> [ 2200.835063] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called=
 with disabled ep ffff8800bc71e480
>> [ 2200.835068] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called=
 with disabled ep ffff8800bc71e4c0
>> [ 2267.897715] sd 9:0:0:0: [sdb] Unhandled sense code
>> [ 2267.897719] sd 9:0:0:0: [sdb] =20
>> [ 2267.897721] Result: hostbyte=3D0x07 driverbyte=3D0x08
>> [ 2267.897722] sd 9:0:0:0: [sdb] =20
>> [ 2267.897724] Sense Key : 0x4 [current]=20
>> [ 2267.897735] sd 9:0:0:0: [sdb] =20
>> [ 2267.897736] ASC=3D0x0 ASCQ=3D0x0
>> [ 2267.897738] sd 9:0:0:0: [sdb] CDB:=20
>> [ 2267.897740] cdb[0]=3D0x28: 28 00 4a 85 6e af 00 00 08 00
>> [ 2267.897746] end_request: I/O error, dev sdb, sector 1250258607
>> [ 2267.897750] Buffer I/O error on device sdb1, logical block 625129=
272
>> [ 2267.897752] Buffer I/O error on device sdb1, logical block 625129=
273
>> [ 2267.897753] Buffer I/O error on device sdb1, logical block 625129=
274
>> [ 2267.897754] Buffer I/O error on device sdb1, logical block 625129=
275
>> [ 2270.884154] usb 1-3: USB disconnect, device number 5
>>=20
>> Bus 001 Device 010: ID 14cd:6116 Super Top M6116 SATA Bridge
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               2.00
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0=20
>>   bDeviceProtocol         0=20
>>   bMaxPacketSize0        64
>>   idVendor           0x14cd Super Top
>>   idProduct          0x6116 M6116 SATA Bridge
>>   bcdDevice            1.50
>>   iManufacturer           1 Super Top  =20
>>   iProduct                3 USB 2.0  SATA BRIDGE  =20
>>   iSerial                 2 M6116018VE15
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength           32
>>     bNumInterfaces          1
>>     bConfigurationValue     1
>>     iConfiguration          0=20
>>     bmAttributes         0xc0
>>       Self Powered
>>     MaxPower                2mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           2
>>       bInterfaceClass         8 Mass Storage
>>       bInterfaceSubClass      6 SCSI
>>       bInterfaceProtocol     80 Bulk-Only
>>       iInterface              0=20
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x02  EP 2 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>> Device Qualifier (for other device speed):
>>   bLength                10
>>   bDescriptorType         6
>>   bcdUSB               2.00
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0=20
>>   bDeviceProtocol         0=20
>>   bMaxPacketSize0        64
>>   bNumConfigurations      1
>> Device Status:     0x0001
>>   Self Powered
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb"=
 in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
