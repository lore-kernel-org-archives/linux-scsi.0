From: Balint Cristian <rezso@rdsor.ro>
Subject: 2.6.9-rc2 on alpha hangs at isp1280[1020] load.
Date: Tue, 16 Nov 2004 02:00:34 +0200
Message-ID: <200411160200.34943.rezso@rdsor.ro>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.rdsor.ro ([193.231.238.10]:32147 "EHLO mail.rdsor.ro")
	by vger.kernel.org with ESMTP id S261696AbUKPAAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 19:00:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-alpha@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi !


 I am getting this while testing 2.6.10-rc2 on my Miata 500 machine,
i really dont know if is a recent cia_core or isp1280 change problem.

Any ideas ?

Please direct me if i am doing something wrong.


Here is the message:
1:1/rezso root=/dev/sda4 video=sisfb:1024x768-16@60 console=ttyS0,9600
aboot> 1
aboot: loading uncompressed rezso...
aboot: loading compressed rezso...
aboot: zero-filling 1086712 bytes at 0xfffffc0001676800
aboot: starting kernel rezso with arguments root=/dev/sda4 video=sisfb:1024x768-16@60 console=ttyS0,9600
Linux version 2.6.10-rc2 (root@alpha.rdsor.ro) (gcc version 3.3.3 20040412 (Red Hat Linux 3.3.3-7)) #1 Tue Nov 16 02:45:00 EET 2004
Booting GENERIC on Miata using machine vector Miata from SRM
Major Options: VERBOSE_MCHECK
Command line: root=/dev/sda4 video=sisfb:1024x768-16@60 console=ttyS0,9600
memcluster 0, usage 1, start        0, end      236
memcluster 1, usage 0, start      236, end    32767
memcluster 2, usage 1, start    32767, end    32768
freeing pages 236:2048
freeing pages 3010:32767
reserving pages 3010:3011
2048K Bcache detected; load hit latency 27 cycles, load miss latency 121 cycles
pci: cia revision 1 (pyxis)
Built 1 zonelists
Kernel command line: root=/dev/sda4 video=sisfb:1024x768-16@60 console=ttyS0,9600
PID hash table entries: 1024 (order: 10, 32768 bytes)
HWRPB cycle frequency bogus.  Estimated 499797860 Hz
Using epoch = 2000
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 5, 262144 bytes)
Memory: 249616k/262136k available (2801k kernel code, 10336k reserved, 456k data, 648k init)
Mount-cache hash table entries: 512 (order: 0, 8192 bytes)
NET: Registered protocol family 16
EISA bus registered
pci: passed tb register update test
pci: passed sg loopback i/o read test
pci: passed pte write cache snoop test
CIA machine check expected.
pci: failed valid tag invalid pte reload test (mcheck; workaround available)
CIA machine check expected.
pci: passed pci machine check test
pci: tbia workaround enabled
pci: enabling save/restore of SRM state
PCI: Bus 1, bridge: 0000:00:14.0
  IO window: 8000-8fff
  MEM window: 09600000-096fffff
  PREFETCH window: 09000000-095fffff
SCSI subsystem initialized
audit: initializing netlink socket (disabled)
audit(1100573387.122:0): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
Initializing Cryptographic API
rtc: SRM (post-2000) epoch (2000) detected
Real Time Clock Driver v1.12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
loop: loaded (max 8 devices)
Linux Tulip driver version 1.1.13 (May 11, 2002)
tulip0:  EEPROM default media type Autosense.
tulip0:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) block.
tulip0:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY (2) block.
tulip0:  Index #2 - Media 10base2 (#1) described by a 21142 Serial PHY (2) block.
tulip0:  Index #3 - Media AUI (#2) described by a 21142 Serial PHY (2) block.
tulip0:  Index #4 - Media MII (#11) described by a 21142 MII PHY (3) block.
tulip0:  MII transceiver #5 config 0000 status 7849 advertising 01e1.
eth0: Digital DS21143 Tulip rev 48 at fffffc8809740000, 00:00:F8:75:90:A0, IRQ 24.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
CMD646: IDE controller at PCI slot 0000:00:04.0
CMD646: chipset revision 1
CMD646: not 100% native mode: will probe irqs later
CMD646: chipset revision 0x01, MultiWord DMA Limited, IRQ workaround enabled
    ide0: BM-DMA at 0x9080-0x9087, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x9088-0x908f, BIOS settings: hdc:pio, hdd:pio
qla1280: QLA1040 found on PCI bus 1, dev 8
Unable to handle kernel paging request at virtual address 000000000000000c
swapper(1): Oops 0
pc = [<fffffc000101ffa8>]  ra = [<fffffc00010203f4>]  ps = 0007    Not tainted
pc is at cia_decode_mchk+0x18/0x390
ra is at cia_machine_check+0xd4/0xe0
v0 = 0000000000000000  t0 = 0000000000000001  t1 = 0000000000000000
t2 = 0000000000000001  t3 = fffffc00016768b0  t4 = 0000000000000400
t5 = 0000000000000000  t6 = fffffc000160bae8  t7 = fffffc000ffb0000
s0 = 0000000000000660  s1 = fffffc0000006068  s2 = fffffc000ffb3c50
s3 = fffffc000ffb4800  s4 = fffffc00016b85b0  s5 = ffffffffffffffed
s6 = 0000000000001c00
a0 = 0000000000000000  a1 = 0000000000000000  a2 = fffffc000ffb3c50
a3 = fffffc000ffb3c50  a4 = 0000000000000000  a5 = 0000000000000000
t8 = 0000000000000000  t9 = 000000005571a184  t10= 0000000000000000
t11= 000000000000000a  pv = fffffc0001020320  at = fffffc0001622420
gp = fffffc0001675b00  sp = fffffc000ffb3c10
Trace:
[<fffffc00010203f4>] cia_machine_check+0xd4/0xe0
[<fffffc0001016c64>] do_entInt+0xd4/0x140
[<fffffc0001010910>] ret_from_sys_call+0x0/0x10
[<fffffc000101ac70>] __raw_readw+0x0/0x40
[<fffffc000101ac84>] __raw_readw+0x14/0x40
[<fffffc0001151dac>] pci_device_probe_static+0x7c/0xa0
[<fffffc0001151e04>] __pci_device_probe+0x34/0x40
[<fffffc0001151e54>] pci_device_probe+0x44/0x90
[<fffffc00011d101c>] driver_probe_device+0x4c/0xb0
[<fffffc00011d1234>] driver_attach+0xb4/0x100
[<fffffc00011d1a74>] bus_add_driver+0xc4/0x190
[<fffffc00011d23c4>] driver_register+0x34/0x50
[<fffffc0001152278>] pci_register_driver+0x58/0x70
[<fffffc0001010168>] init+0x48/0x190
[<fffffc0001010cc8>] kernel_thread+0x28/0x90

Code: 27bb0065  23bd5b70  23defff0  47ff0400  b53e0008  b75e0000 <a030000c> 4821f621
Kernel panic - not syncing: Attempted to kill init!


Please CC me I am not on linux-scsi list.
