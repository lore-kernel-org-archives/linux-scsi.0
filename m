From: Eero Volotinen <eero.volotinen@iki.fi>
Subject: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3 rack
 server
Date: Fri, 22 Aug 2008 14:07:39 +0300
Message-ID: <48AE9DFB.7070502@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pokat.org ([193.208.0.238]:56182 "EHLO pokat.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYHVLIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 07:08:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by pokat.org (Postfix) with ESMTP id 32BA0F7137
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 14:08:11 +0300 (EEST)
Received: from pokat.org ([127.0.0.1])
	by localhost (pokat.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r2KRkfLoS81I for <linux-scsi@vger.kernel.org>;
	Fri, 22 Aug 2008 14:07:49 +0300 (EEST)
Received: from [87.93.11.162] (h011162.gprs.dnafinland.fi [87.93.11.162])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: eero.volotinen@pokat.org)
	by pokat.org (Postfix) with ESMTP id 37972F718B
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 14:07:46 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am (un)happy owner of FSC rx200-s3 server that contains internal
sas hardware raid. Datasheet says that server is linux compatible,
but it is using buggy hardware or software?

Mainly under write i/o load to internal sas raid, the server crashes
or hangs.

Any fix for this issue? I reported it to manufacturer, but without
commercial maintenace license, they don't want to fix this issue.

System is tested with SLES 10 and Centos 5 and almost latest Linux
kernel with Centos LiveCd..

Of course it is possible to get server working using external
raid controller, but this server is advertised as Linux compatible..
Any help?

Description of problem:

Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SAS Host driver 3.04.02-suse
GSI 21 sharing vector 0x5A and IRQ 21
ACPI: PCI Interrupt 0000:05:05.0[A] -> GSI 24 (level, low) -> IRQ 90
mptbase: Initiating ioc0 bringup
ioc0: SAS1068: Capabilities={Initiator}
scsi4 : ioc0: LSISAS1068, FwRev=01122800h, Ports=1, MaxQ=511, IRQ=90
   Vendor: FUJITSU   Model: MAY2073RC         Rev: 5204
   Type:   Direct-Access                      ANSI SCSI revision: 03
  4:0:0:0: Attached scsi generic sg3 type 0
   Vendor: FUJITSU   Model: MAY2073RC         Rev: 5204
   Type:   Direct-Access                      ANSI SCSI revision: 03
  4:0:1:0: Attached scsi generic sg4 type 0
   Vendor: LSILOGIC  Model: Logical Volume    Rev: 3000
   Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 142577664 512-byte hdwr sectors (73000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 03 00 00 08
SCSI device sdc: drive cache: write through
SCSI device sdc: 142577664 512-byte hdwr sectors (73000 MB)
sdc: Write Protect is off
sdc: Mode Sense: 03 00 00 08
SCSI device sdc: drive cache: write through
  sdc: sdc1 sdc2
sd 4:1:0:0: Attached scsi disk sdc
sd 4:1:0:0: Attached scsi generic sg5 type 0
Hotpluggable processor device is not present
Hotpluggable processor device is not present
Hotpluggable processor device is not present
Hotpluggable processor device is not present
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 4200956k swap on 
/dev/disk/by-id/scsi-3600508e0000000000eac23ff6ce6ea0d-part1. 
Priority:-1 extents:1 across:4200956k
tg3.c:v3.71b (December 15, 2006)
ACPI: PCI Interrupt 0000:08:04.0[A] -> GSI 16 (level, low) -> IRQ 169
eth0: Tigon3 [partno(BCM95715) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 
10/100/1000Base-T Ethernet 00:0a:e4:82:11:aa
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] 
TSOcap[1]
eth0: dma_rwctrl[76148000] dma_mask[40-bit]
ACPI: PCI Interrupt 0000:08:04.1[B] -> GSI 17 (level, low) -> IRQ 177
Fusion MPT misc device (ioctl) driver 3.04.02-suse
eth1: Tigon3 [partno(BCM95715) rev 9003 PHY(5714)] (PCIX:133MHz:64-bit) 
10/100/1000Base-T Ethernet 00:0a:e4:82:11:ab
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] 
TSOcap[1]
eth1: dma_rwctrl[76148000] dma_mask[40-bit]
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
hw_random: RNG not detected
usbcore: registered new driver usbfs
usbcore: registered new driver hub
GSI 22 sharing vector 0x62 and IRQ 22
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 98
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: irq 98, io mem 0xfc000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.16.46-0.12-smp ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 98
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 98, io base 0x00001000
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.16.46-0.12-smp uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
GSI 23 sharing vector 0x6A and IRQ 23
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 106
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 106, io base 0x00001400
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.16.46-0.12-smp uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
GSI 24 sharing vector 0x72 and IRQ 24
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 114
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 114, io base 0x00001800
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.16.46-0.12-smp uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
GSI 25 sharing vector 0x7A and IRQ 25
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 20 (level, low) -> IRQ 122
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 122, io base 0x00001c00
usb usb5: new device found, idVendor=0000, idProduct=0000
usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.16.46-0.12-smp uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 4-1: new full speed USB device using uhci_hcd and address 2
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
usb 4-1: new device found, idVendor=0000, idProduct=0000
usb 4-1: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-1: Product: iRMC USB Device
usb 4-1: Manufacturer: FSC
usb 4-1: SerialNumber: 4004C390762534
usb 4-1: configuration #1 chosen from 1 choice
device-mapper: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
dm-netlink version 0.0.2 loaded
usbcore: registered new driver hiddev
input: FSC iRMC USB Device as /class/input/input3
input: USB HID v1.11 Keyboard [FSC iRMC USB Device] on usb-0000:00:1d.2-1
input: FSC iRMC USB Device as /class/input/input4
input: USB HID v1.11 Mouse [FSC iRMC USB Device] on usb-0000:00:1d.2-1
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
loop: loaded (max 8 devices)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
AppArmor: AppArmor (version 2.0-19.43r6320) initialized
audit(1219316096.212:2): AppArmor (version 2.0-19.43r6320) initialized

parted[2535] trap divide error rip:2b18112ca781 rsp:7fff99920ec0 error:0
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
audit(1219305299.965:3): audit_pid=3037 old=0 by auid=4294967295
IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
IA-32 Microcode Update Driver v1.14 unregistered
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
st: Version 20050830, fixed bufsize 32768, s/g segs 256
NET: Registered protocol family 17
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
mptbase: Initiating ioc0 recovery
ibm_acpi: ec object not found
sony_acpi: module not supported by Novell, setting U taint flag.
pcc_acpi: module not supported by Novell, setting U taint flag.
mptbase: Initiating ioc0 recovery
audit(1219309592.457:7): audit_pid=0 old=3037 by auid=4294967295
audit(1219309592.529:8): audit_pid=11640 old=0 by auid=4294967295
mptscsih: ioc0: attempting task abort! (sc=ffff81005a09bc80)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 17 22 03 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81005a09bc80)
mptscsih: ioc0: attempting task abort! (sc=ffff81006b7779c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 17 1e 03 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81006b7779c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81006921d240)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 17 1a 03 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81006921d240)
mptscsih: ioc0: attempting task abort! (sc=ffff81006b7776c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 56 9b 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81006b7776c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81007fa326c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 52 9b 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81007fa326c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81004bf4ae00)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 0d ca 73 00 00 10 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004bf4ae00)
mptscsih: ioc0: attempting task abort! (sc=ffff81004cac1540)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 17 16 03 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004cac1540)
mptscsih: ioc0: attempting task abort! (sc=ffff81007fa32cc0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 c8 cb 00 01 18 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81007fa32cc0)
mptscsih: ioc0: attempting task abort! (sc=ffff81004d32ab00)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 17 05 db 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004d32ab00)
mptscsih: ioc0: attempting task abort! (sc=ffff81002f6ef200)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 b1 63 00 02 e8 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81002f6ef200)
mptscsih: ioc0: attempting task abort! (sc=ffff81004a12b240)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 74 f3 00 00 38 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004a12b240)
mptscsih: ioc0: attempting task abort! (sc=ffff81007fa329c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 48 63 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81007fa329c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81005a09b080)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 38 63 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81005a09b080)
mptscsih: ioc0: attempting task abort! (sc=ffff81004a12b3c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 a9 63 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004a12b3c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81007cb60980)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 0d 88 53 00 00 08 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81007cb60980)
mptscsih: ioc0: attempting task abort! (sc=ffff81006921d3c0)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 70 0b 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81006921d3c0)
mptscsih: ioc0: attempting task abort! (sc=ffff81005a09b200)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 e5 eb 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81005a09b200)
mptscsih: ioc0: attempting task abort! (sc=ffff81004cac1e40)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 0d a4 c3 00 00 08 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004cac1e40)
mptscsih: ioc0: attempting task abort! (sc=ffff81004d32ae00)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 a1 63 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81004d32ae00)
mptscsih: ioc0: attempting task abort! (sc=ffff81002f6ef800)
sd 4:1:0:0:
         command: Write(10): 2a 00 02 16 ed f3 00 04 00 00
mptscsih: ioc0: task abort: FAILED (sc=ffff81002f6ef800)
mptscsih: ioc0: attempting task abort! (sc=ffff81002f6ef680)
sd 4:1:0:0:

Server is running 64bit Linux kernel. Same issue occurs with
any tested kernel when I try to copy 1.6GB size file over
scp link.

Thanks for any help.

