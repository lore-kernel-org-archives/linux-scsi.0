From: Frederic Corne <fcorne@free.fr>
Subject: problem of re-insertion of a scsi card
Date: Fri, 19 Sep 2003 18:16:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6B2BE5.4070006@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fcorne.net1.nerim.net ([62.4.18.158]:8587 "EHLO
	poussindev.home.net") by vger.kernel.org with ESMTP id S261645AbTISQQl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2003 12:16:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,
I have a problem with a pcmcia scsi card. I have posted the question on
the pcmcia-cs forum . But one tells me that it's a hot plug problem.
I posted on the hotplug forum. But one tells me that it's not really a hotplug issue...

So I post the question on this list with hope it is the appropiate list ! 

The problem :

I have a Adaptec 1480 card to which I connect a scanner and a cdrw.
When I first insert the card , all is ok , the scanner and the cdrw work
nicelly.
But if I eject the card and later re-insert it , the card is recognized
but the scsi chain is not re-initialized. There is not any entry in the
scsi subsystem.

I have tryied to reload some kernel modules without success.

what can I do ?

More : if I eject and re-insert again the card sometime I get immediately a general kernel faillure ...

Any help will be very appreciated.

FC


here is the logs

the machine is a basic Mandrake 9.1
kernel 2.4.21-0.25mdk
pcmcia-cs-3.2.3-5mdk
hotplug-2002_04_01-8mdk


I first insert the card.
tail /var/log/message
( a lot of error about irda that I have not yet corrected because the
notebock is upon a dock)

Sep 6 22:12:52 poussindev kernel: cs: cb_alloc(bus 21): vendor 0x9004,
device 0x6075
Sep 6 22:12:52 poussindev kernel: PCI: Enabling device 15:00.0 (0000 -> 0003)
Sep 6 22:12:52 poussindev cardmgr[19056]: socket 1: CardBus hotplug device
Sep 6 22:12:52 poussindev /etc/hotplug/pci.agent: pcimodules is scanning
more than ...
Sep 6 22:12:52 poussindev /etc/hotplug/pci.agent: Setup aic7xxx 3c59x
yenta_socket toshoboe donauboe eepro100 e100 usb-uhci uhci neofb for PCI
slot 15:00.0
Sep 6 22:12:52 poussindev kernel: ahc_pci:21:0:0: Host Adapter Bios
disabled. Using default SCSI device parameters
Sep 6 22:12:52 poussindev kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI
SCSI HBA DRIVER, Rev 6.2.8
Sep 6 22:12:52 poussindev kernel: <Adaptec 1480A Ultra SCSI adapter>
Sep 6 22:12:52 poussindev kernel: aic7860: Ultra Single Channel A, SCSI
Id=7, 3/253 SCBs
Sep 6 22:12:52 poussindev kernel:
Sep 6 22:13:09 poussindev kernel: Vendor: YAMAHA Model: CRW4416S Rev: 1.0j
Sep 6 22:13:09 poussindev kernel: Type: CD-ROM ANSI SCSI revision: 02
Sep 6 22:13:09 poussindev kernel: Vendor: UMAX Model: Astra 1220S Rev: V1.3
Sep 6 22:13:09 poussindev kernel: Type: Scanner ANSI SCSI revision: 02
Sep 6 22:13:09 poussindev kernel: Attached scsi CD-ROM sr0 at scsi0,
channel 0, id 5, lun 0
Sep 6 22:13:09 poussindev kernel: Attached scsi generic sg1 at scsi0,
channel 0, id 6, lun 0, type 6
Sep 6 22:13:09 poussindev kernel: (scsi0:A:5): 8.333MB/s transfers
(8.333MHz, offset 15)
Sep 6 22:13:09 poussindev kernel: sr0: scsi3-mmc drive: 16x/16x writer
cd/rw xa/form2 cdda tray
Sep 6 22:13:10 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/irda/donauboe.o.gz:
init_module: No such device
Sep 6 22:13:10 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:13:10 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/irda/donauboe.o.gz failed
Sep 6 22:13:10 poussindev modprobe: modprobe: insmod donauboe failed
Sep 6 22:13:10 poussindev /etc/hotplug/pci.agent: ... can't load module
donauboe
Sep 6 22:13:10 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver donauboe
Sep 6 22:13:11 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/e100/e100.o.gz:
init_module: No such device
Sep 6 22:13:11 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:13:11 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/e100/e100.o.gz failed
Sep 6 22:13:11 poussindev modprobe: modprobe: insmod e100 failed
Sep 6 22:13:11 poussindev /etc/hotplug/pci.agent: ... can't load module e100
Sep 6 22:13:11 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver e100
Sep 6 22:13:11 poussindev /etc/hotplug/pci.agent: ... blacklisted module:
usb-uhci
Sep 6 22:13:11 poussindev kernel: uhci.c: USB Universal Host Controller
Interface driver v1.1
Sep 6 22:13:11 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/usb/uhci.o.gz: init_module: No
such device
Sep 6 22:13:11 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:13:11 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/usb/uhci.o.gz failed
Sep 6 22:13:11 poussindev modprobe: modprobe: insmod uhci failed
Sep 6 22:13:11 poussindev /etc/hotplug/pci.agent: ... can't load module uhci
Sep 6 22:13:11 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver uhci


# dump_cis
Socket 0:
manfid 0x0101, 0x5257
config_cb base 0x0000 last_index 0x01
cftable_entry_cb 0x01 [default]
[master]
Vcc Vnom 3300mV
Vpp1 Vnom 3300mV
io_base 1
irq mask 0xffff [level]
BAR 1 size 64b [io]
vers_1 5.0, "3Com Corporation", "3CCFE575CT", "LAN Cardbus Card",
"004"
funcid network_adapter [post]

Socket 1:
manfid 0x012f, 0xcb01
vers_1 5.0, "Adaptec", "APA-1480 SCSI Host Adapter",
"Version 1.10 ", ""
funcid scsi_adapter
BAR 1 size 256b [io]
BAR 2 size 256b [mem]
BAR 7 size 2kb [mem]
config_cb base 0x00f2 last_index 0x00
cftable_entry_cb 0x00 [default]
Vcc Vnom 3300mV Istatic 150mA Iavg 230mA Ipeak 300mA
io_base 1
irq mask 0xffff [level] [shared]
mem_base 2 7



# cardctl status
Socket 0:
3.3V CardBus card
function 0: [ready]
Socket 1:
3.3V CardBus card
function 0: [ready]

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 05 Lun: 00
Vendor: YAMAHA Model: CRW4416S Rev: 1.0j
Type: CD-ROM ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
Vendor: UMAX Model: Astra 1220S Rev: V1.3
Type: Scanner ANSI SCSI revision: 02


As you see all is ok . the scanner and the cdrw work nicelly.

Now I eject the card :
# cardctl eject 1
tail /var/log/message
Sep 6 22:18:56 poussindev kernel: cs: cb_free(bus 21)
Sep 6 22:18:56 poussindev /etc/hotplug/pci.agent: PCI remove event not
supported

# cardctl status
Socket 0:
3.3V CardBus card
function 0: [ready]
Socket 1:
no card

# cat /proc/scsi/scsi
Attached devices: none
# lsmod
Module Size Used by Not tainted
aic7xxx 128536 0 (unused)
ipt_state 1080 2 (autoclean)
ipt_REJECT 3768 1 (autoclean)
ipt_LOG 4280 1 (autoclean)
iptable_filter 2348 1 (autoclean)
ip_nat_ftp 4016 0 (unused)
iptable_nat 21016 2 [ip_nat_ftp]
ip_conntrack_ftp 5200 1
ip_conntrack 27432 3 [ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
ip_tables 14648 7 [ipt_state ipt_REJECT ipt_LOG iptable_filter iptable_nat]
ppp_synctty 7488 0 (unused)
ppp_async 9216 1
ppp_generic 24060 3 [ppp_synctty ppp_async]
slhc 6564 0 [ppp_generic]
lp 8096 0
parport_pc 25096 1
parport 34176 1 [lp parport_pc]
sg 34636 0 (autoclean) (unused)
st 29488 0 (autoclean) (unused)
sr_mod 16952 0 (autoclean) (unused)
sd_mod 13132 0 (autoclean) (unused)
scsi_mod 103540 5 (autoclean) [aic7xxx sg st sr_mod sd_mod]
neofb 15560 0 (unused)
nfsd 74256 8 (autoclean)
toshoboe 7400 0 (unused)
irda 112112 0 [toshoboe]
3c59x 29584 1
ds 8456 2
yenta_socket 13056 2
pcmcia_core 57184 0 [ds yenta_socket]
af_packet 14952 2 (autoclean)
ide-floppy 15580 0 (autoclean)
ide-tape 48304 0 (autoclean)
ide-cd 33856 0 (autoclean)
cdrom 31648 0 (autoclean) [sr_mod ide-cd]
floppy 55100 0
eepro100 21844 1 (autoclean)
mii 3832 0 (autoclean) [eepro100]
supermount 15296 2 (autoclean)
usb-uhci 24684 0 (unused)
usbcore 72992 1 [usb-uhci]
rtc 8060 0 (autoclean)
ext3 59756 4
jbd 39100 4 [ext3]

# rmmod aic7xxx
# rmmod -a

Now I re-insert the card :


tail /var/log/message :


Sep 6 22:45:51 poussindev kernel: cs: cb_alloc(bus 21): vendor 0x9004,
device 0x6075
Sep 6 22:45:51 poussindev kernel: PCI: Enabling device 15:00.0 (0000 -> 0003)
Sep 6 22:45:51 poussindev /etc/hotplug/pci.agent: pcimodules is scanning
more than ...
Sep 6 22:45:51 poussindev /etc/hotplug/pci.agent: Setup aic7xxx 3c59x
yenta_socket toshoboe donauboe eepro100 e100 usb-uhci uhci neofb for PCI
slot 15:00.0
Sep 6 22:45:53 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/irda/donauboe.o.gz:
init_module: No such device
Sep 6 22:45:53 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:45:53 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/irda/donauboe.o.gz failed
Sep 6 22:45:53 poussindev modprobe: modprobe: insmod donauboe failed
Sep 6 22:45:53 poussindev /etc/hotplug/pci.agent: ... can't load module
donauboe
Sep 6 22:45:53 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver donauboe
Sep 6 22:45:53 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/e100/e100.o.gz:
init_module: No such device
Sep 6 22:45:53 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:45:53 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/net/e100/e100.o.gz failed
Sep 6 22:45:53 poussindev modprobe: modprobe: insmod e100 failed
Sep 6 22:45:53 poussindev /etc/hotplug/pci.agent: ... can't load module e100
Sep 6 22:45:53 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver e100
Sep 6 22:45:53 poussindev /etc/hotplug/pci.agent: ... blacklisted module:
usb-uhci
Sep 6 22:45:54 poussindev kernel: uhci.c: USB Universal Host Controller
Interface driver v1.1
Sep 6 22:45:54 poussindev insmod:
/lib/modules/2.4.21-0.25mdk/kernel/drivers/usb/uhci.o.gz: init_module: No
such device
Sep 6 22:45:54 poussindev insmod: Hint: insmod errors can be caused by
incorrect module parameters, including invalid IO or IRQ parameters. You
may find more information in syslog or the output from dmesg
Sep 6 22:45:54 poussindev modprobe: modprobe: insmod
/lib/modules/2.4.21-0.25mdk/kernel/drivers/usb/uhci.o.gz failed
Sep 6 22:45:54 poussindev modprobe: modprobe: insmod uhci failed
Sep 6 22:45:54 poussindev /etc/hotplug/pci.agent: ... can't load module uhci
Sep 6 22:45:54 poussindev /etc/hotplug/pci.agent: missing kernel or user
mode driver uhci


# dump_cis
Socket 0:
manfid 0x0101, 0x5257
config_cb base 0x0000 last_index 0x01
cftable_entry_cb 0x01 [default]
[master]
Vcc Vnom 3300mV
Vpp1 Vnom 3300mV
io_base 1
irq mask 0xffff [level]
BAR 1 size 64b [io]
vers_1 5.0, "3Com Corporation", "3CCFE575CT", "LAN Cardbus Card",
"004"
funcid network_adapter [post]

Socket 1:
manfid 0x012f, 0xcb01
vers_1 5.0, "Adaptec", "APA-1480 SCSI Host Adapter",
"Version 1.10 ", ""
funcid scsi_adapter
BAR 1 size 256b [io]
BAR 2 size 256b [mem]
BAR 7 size 2kb [mem]
config_cb base 0x00f2 last_index 0x00
cftable_entry_cb 0x00 [default]
Vcc Vnom 3300mV Istatic 150mA Iavg 230mA Ipeak 300mA
io_base 1
irq mask 0xffff [level] [shared]
mem_base 2 7

# cardctl status
Socket 0:
3.3V CardBus card
function 0: [ready]
Socket 1:
3.3V CardBus card
function 0: [ready]

BUT THERE IS NOT SCSI !!! :

cat /proc/scsi/scsi
Attached devices: none



