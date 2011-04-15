From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc3-git3 boot problems
Date: Fri, 15 Apr 2011 19:09:12 -0400
Message-ID: <web-506037045@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zfrontend1.aha.ru ([195.2.83.147]:60999 "EHLO zfrontend1.aha.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1DOXJP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2011 19:09:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>, gregkh@suse.de, tj@kernel.org, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

1) Pls someone correct this:
/drivers/edac/i82975x_edac.c:298:   integer constant too 
large for 'unsigned long' type

2) With -git4  AND  the patches to blk and scsi mailed to 
me, it's better, but still crashs.   Pls see below.

I really don't know, but I suspect the problems have to do 
something with khugepaged , because at least subjectively 
the problem is similar like earlier (i think it was at 
2.6.38-rc1 or 37-rc1) when that gave problems and was 
corrected, but perhaps the correction at that time wasnt 
sufficient.

Now, the crashs happens if I do something what have to do 
with unzip, perhaps because of big memory use.  One time, 
when it crashs, top  showed  flush -8:0  active.  This can 
be ocasionally, or not.

W.Landgraf

Linux  SYS


====================
Apr 15 17:41:13 werner kernel: Malformed early option 
'acpi'
Apr 15 17:41:13 werner kernel: ACPI: RSDP 000fb9f0 00024 
(v02 ACPIAM)
Apr 15 17:41:13 werner kernel: ACPI: XSDT affc0100 0004C 
(v01 A_M_I_ OEMXSDT  01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: ACPI: FACP affc0290 000F4 
(v03 A_M_I_ OEMFACP  01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: ACPI: DSDT affc0440 04DAE 
(v01  A0647 A0647000 00000000 INTL 02002026)
Apr 15 17:41:13 werner kernel: ACPI: FACS affce000 00040
Apr 15 17:41:13 werner kernel: ACPI: APIC affc0390 00070 
(v01 A_M_I_ OEMAPIC  01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: ACPI: MCFG affc0400 0003C 
(v01 A_M_I_ OEMMCFG  01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: ACPI: OEMB affce040 00060 
(v01 A_M_I_ AMI_OEM  01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: ACPI: HPET affc51f0 00038 
(v01 A_M_I_ OEMHPET0 01000715 MSFT 00000097)
Apr 15 17:41:13 werner kernel: Zone PFN ranges:
Apr 15 17:41:13 werner kernel:   DMA      0x00000010 -> 
0x00001000
Apr 15 17:41:13 werner kernel:   Normal   0x00001000 -> 
0x000377fe
Apr 15 17:41:13 werner kernel:   HighMem  0x000377fe -> 
0x000affc0
Apr 15 17:41:13 werner kernel: Movable zone start PFN for 
each node
Apr 15 17:41:13 werner kernel: early_node_map[2] active 
PFN ranges
Apr 15 17:41:13 werner kernel:     0: 0x00000010 -> 
0x0000009f
Apr 15 17:41:13 werner kernel:     0: 0x00000100 -> 
0x000affc0
Apr 15 17:41:13 werner kernel: Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 715087
Apr 15 17:41:13 werner kernel: Fast TSC calibration using 
PIT
Apr 15 17:41:13 werner kernel: Detected 2410.835 MHz 
processor.
Apr 15 17:41:13 werner kernel: ACPI: setting ELCR to 0200 
(from 8c00)
Apr 15 17:41:13 werner kernel: AMD PMU driver.
Apr 15 17:41:13 werner kernel: raid6: int32x1    617 MB/s
Apr 15 17:41:13 werner kernel: raid6: int32x2    820 MB/s
Apr 15 17:41:13 werner kernel: raid6: int32x4    675 MB/s
Apr 15 17:41:13 werner kernel: raid6: int32x8    519 MB/s
Apr 15 17:41:13 werner kernel: raid6: mmxx1     1921 MB/s
Apr 15 17:41:13 werner kernel: raid6: mmxx2     3214 MB/s
Apr 15 17:41:13 werner kernel: raid6: sse1x1    1871 MB/s
Apr 15 17:41:13 werner kernel: raid6: sse1x2    3148 MB/s
Apr 15 17:41:13 werner kernel: raid6: sse2x1    3187 MB/s
Apr 15 17:41:13 werner kernel: raid6: sse2x2    4218 MB/s
Apr 15 17:41:13 werner kernel: raid6: using algorithm 
sse2x2 (4218 MB/s)
Apr 15 17:41:13 werner kernel: ACPI: Executed 1 blocks of 
module-level executable AML code
Apr 15 17:41:13 werner kernel: mdacon: MDA with 8K of 
memory detected.
Apr 15 17:41:13 werner kernel: microcode: CPU0: family 15 
not supported
Apr 15 17:41:13 werner kernel: highmem bounce pool size: 
64 pages
Apr 15 17:41:13 werner kernel: Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Apr 15 17:41:13 werner kernel: DLM (built Apr 15 2011 
15:45:58) installed
Apr 15 17:41:13 werner kernel: EFS: 1.0a - 
http://aeschi.ch.eu.org/efs/
Apr 15 17:41:13 werner kernel: OCFS2 User DLM kernel 
interface loaded
Apr 15 17:41:13 werner kernel: GFS2 (built Apr 15 2011 
15:47:14) installed
Apr 15 17:41:13 werner kernel: acpiphp_ibm: 
ibm_acpiphp_init: acpi_walk_namespace failed
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LMC9] enabled at IRQ 11
Apr 15 17:41:13 werner kernel: nvidiafb: CRTC0 analog 
found
Apr 15 17:41:13 werner kernel: nvidiafb: CRTC1 analog not 
found
Apr 15 17:41:13 werner kernel: i2c i2c-0: unable to read 
EDID block.
Apr 15 17:41:13 werner last message repeated 2 times
Apr 15 17:41:13 werner kernel: nvidiafb: EDID found from 
BUS2
Apr 15 17:41:13 werner kernel: nvidiafb: CRTC 0 appears to 
have a CRT attached
Apr 15 17:41:13 werner kernel: nvidiafb: Using CRT on CRTC 
0
Apr 15 17:41:13 werner kernel: Could not find Carillo 
Ranch MCH device.
Apr 15 17:41:13 werner kernel: no IO addresses supplied
Apr 15 17:41:13 werner kernel: hgafb: probe of hgafb.0 
failed with error -22
Apr 15 17:41:13 werner kernel: uvesafb: failed to execute 
/sbin/v86d
Apr 15 17:41:13 werner kernel: uvesafb: make sure that the 
v86d helper is installed and executable
Apr 15 17:41:13 werner kernel: uvesafb: Getting VBE info 
block failed (eax=0x4f00, err=-2)
Apr 15 17:41:13 werner kernel: uvesafb: vbe_init() failed 
with -22
Apr 15 17:41:13 werner kernel: uvesafb: probe of uvesafb.0 
failed with error -22
Apr 15 17:41:13 werner kernel: vesafb: cannot reserve 
video memory at 0xc0000000
Apr 15 17:41:13 werner kernel: toshiba: not a supported 
Toshiba laptop
Apr 15 17:41:13 werner kernel: Compaq SMART2 Driver (v 
2.6.0)
Apr 15 17:41:13 werner kernel: i2c-core: driver [isl29003] 
using legacy suspend method
Apr 15 17:41:13 werner kernel: i2c-core: driver [isl29003] 
using legacy resume method
Apr 15 17:41:13 werner kernel: Loading Adaptec I2O RAID: 
Version 2.4 Build 5go
Apr 15 17:41:13 werner kernel: scsi: <fdomain> Detection 
failed (no card)
Apr 15 17:41:13 werner kernel: NCR53c406a: no available 
ports found
Apr 15 17:41:13 werner kernel: Emulex LightPulse Fibre 
Channel SCSI driver 8.3.22
Apr 15 17:41:13 werner kernel: Copyright(c) 2004-2009 
Emulex.  All rights reserved.
Apr 15 17:41:13 werner kernel: Failed initialization of 
WD-7000 SCSI card!
Apr 15 17:41:13 werner kernel: GDT-HA: Storage RAID 
Controller Driver. Version: 3.05
Apr 15 17:41:13 werner kernel: 3ware Storage Controller 
device driver for Linux v1.26.02.003.
Apr 15 17:41:13 werner kernel: 3ware 9000 Storage 
Controller device driver for Linux v2.26.02.014.
Apr 15 17:41:13 werner kernel: imm: Version 2.05 (for 
Linux 2.4.0)
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LSA0] enabled at IRQ 15
Apr 15 17:41:13 werner kernel: Error: Driver 
'pata_platform' is already registered, aborting...
Apr 15 17:41:13 werner kernel: mtdoops: mtd device 
(mtddev=name/number) must be supplied
Apr 15 17:41:13 werner kernel: physmap-flash.0: failed to 
claim resource 0
Apr 15 17:41:13 werner kernel: Failed to ioremap_nocache
Apr 15 17:41:13 werner last message repeated 2 times
Apr 15 17:41:13 werner kernel: SNAPGEAR: failed to 
ioremap() BOOTCS
Apr 15 17:41:13 werner kernel: Generic platform RAM MTD, 
(c) 2004 Simtec Electronics
Apr 15 17:41:13 werner kernel: [nandsim] warning: 
read_byte: unexpected data output cycle, state is 
STATE_READY return 0x0
Apr 15 17:41:13 werner last message repeated 5 times
Apr 15 17:41:13 werner kernel: flash size: 8 MiB
Apr 15 17:41:13 werner kernel: page size: 512 bytes
Apr 15 17:41:13 werner kernel: OOB area size: 16 bytes
Apr 15 17:41:13 werner kernel: sector size: 8 KiB
Apr 15 17:41:13 werner kernel: pages number: 16384
Apr 15 17:41:13 werner kernel: pages per sector: 16
Apr 15 17:41:13 werner kernel: bus width: 8
Apr 15 17:41:13 werner kernel: bits in sector size: 13
Apr 15 17:41:13 werner kernel: bits in page size: 9
Apr 15 17:41:13 werner kernel: bits in OOB size: 4
Apr 15 17:41:13 werner kernel: flash size with OOB: 8448 
KiB
Apr 15 17:41:13 werner kernel: page address bytes: 3
Apr 15 17:41:13 werner kernel: sector address bytes: 2
Apr 15 17:41:13 werner kernel: options: 0x62
Apr 15 17:41:13 werner kernel: onenand_wait: timeout! 
ctrl=0x0000 intr=0x0000
Apr 15 17:41:13 werner kernel: DE600: port 0x378 busy
Apr 15 17:41:13 werner kernel: paride: aten registered as 
protocol 0
Apr 15 17:41:13 werner kernel: paride: bpck registered as 
protocol 1
Apr 15 17:41:13 werner kernel: paride: comm registered as 
protocol 2
Apr 15 17:41:13 werner kernel: paride: dstr registered as 
protocol 3
Apr 15 17:41:13 werner kernel: paride: k951 registered as 
protocol 4
Apr 15 17:41:13 werner kernel: paride: k971 registered as 
protocol 5
Apr 15 17:41:13 werner kernel: paride: epat registered as 
protocol 6
Apr 15 17:41:13 werner kernel: paride: epia registered as 
protocol 7
Apr 15 17:41:13 werner kernel: paride: frpw registered as 
protocol 8
Apr 15 17:41:13 werner kernel: paride: friq registered as 
protocol 9
Apr 15 17:41:13 werner kernel: paride: fit2 registered as 
protocol 10
Apr 15 17:41:13 werner kernel: paride: fit3 registered as 
protocol 11
Apr 15 17:41:13 werner kernel: paride: on20 registered as 
protocol 12
Apr 15 17:41:13 werner kernel: paride: on26 registered as 
protocol 13
Apr 15 17:41:13 werner kernel: paride: ktti registered as 
protocol 14
Apr 15 17:41:13 werner kernel: paride: bpck6 registered as 
protocol 15
Apr 15 17:41:13 werner kernel: pd: pd version 1.05, major 
45, cluster 64, nice 0
Apr 15 17:41:13 werner kernel: pda: Autoprobe failed
Apr 15 17:41:13 werner kernel: pd: no valid drive found
Apr 15 17:41:13 werner kernel: pcd: pcd version 1.07, 
major 46, nice 0
Apr 15 17:41:13 werner kernel: pcd0: Autoprobe failed
Apr 15 17:41:13 werner kernel: pcd: No CD-ROM drive found
Apr 15 17:41:13 werner kernel: pf: pf version 1.04, major 
47, cluster 64, nice 0
Apr 15 17:41:13 werner kernel: pf: No ATAPI disk detected
Apr 15 17:41:13 werner kernel: pt: pt version 1.04, major 
96
Apr 15 17:41:13 werner kernel: sr0: scsi3-mmc drive: 
48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr 15 17:41:13 werner kernel: pt0: Autoprobe failed
Apr 15 17:41:13 werner kernel: pt: No ATAPI tape drive 
detected
Apr 15 17:41:13 werner kernel: pg: pg version 1.02, major 
97
Apr 15 17:41:13 werner kernel: pga: Autoprobe failed
Apr 15 17:41:13 werner kernel: pg: No ATAPI device 
detected
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 10
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LUB0] enabled at IRQ 11
Apr 15 17:41:13 werner kernel: GTCO usb driver version: 
2.00.0006
Apr 15 17:41:13 werner kernel: mk712: device not present
Apr 15 17:41:13 werner kernel: wistron_btns: System 
unknown
Apr 15 17:41:13 werner kernel: EISA: Cannot allocate 
resource for mainboard
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 1
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 2
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 3
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 4
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 5
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 6
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 7
Apr 15 17:41:13 werner kernel: Cannot allocate resource 
for EISA slot 8
Apr 15 17:41:13 werner kernel: dell-wmi: No known WMI GUID 
found
Apr 15 17:41:13 werner kernel: This machine doesn't have 
MSI-hotkeys through WMI
Apr 15 17:41:13 werner kernel: [Firmware Bug]: 
powernow-k8: No PSB or ACPI _PSS objects
Apr 15 17:41:13 werner kernel: powernow-k8: Make sure that 
your BIOS is up to date and Cool'N'Quiet support is 
enabled in BIOS setup
Apr 15 17:41:13 werner kernel: usb 2-3: device descriptor 
read/64, error -62
Apr 15 17:41:13 werner last message repeated 3 times
Apr 15 17:41:13 werner kernel: usb 2-3: device not 
accepting address 4, error -62
Apr 15 17:41:13 werner kernel: usb 2-3: device not 
accepting address 5, error -62
Apr 15 17:41:13 werner kernel: hub 2-0:1.0: unable to 
enumerate USB device on port 3
Apr 15 17:41:13 werner kernel: udevd (2740): 
/proc/2740/oom_adj is deprecated, please use 
/proc/2740/oom_score_adj instead.
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LNEA] enabled at IRQ 11
Apr 15 17:41:13 werner kernel: k8temp 0000:00:18.3: 
Temperature readouts might be wrong - check erratum #141
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LNKB] enabled at IRQ 11
Apr 15 17:41:13 werner kernel: ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 11
Apr 15 17:41:13 werner kernel: EXT3-fs (sda1): warning: 
mounting fs with errors, running e2fsck is recommended
Apr 15 17:41:13 werner kernel: rt2860sta: module is from 
the staging directory, the quality is unknown, you have 
been warned.
Apr 15 17:41:13 werner kernel: EXT3-fs (sda3): warning: 
maximal mount count reached, running e2fsck is recommended
Apr 15 17:41:16 werner udevd-event[5438]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr 15 17:41:16 werner udevd-event[5443]: 
udev_rules_apply_format: unknown format variable 
'$modalias | grep -q eagle-usb || exit; while ! 
/sbin/eaglectrl -p 2>/dev/null | /bin/grep -q 
Post-firmware; do sleep 2; done; /sbin/eaglectrl -d''
Apr 15 17:41:27 werner apcupsd[5416]: apcupsd FATAL ERROR 
in smartsetup.c at line 171 PANIC! Cannot communicate with 
UPS via serial port. Please make sure the port specified 
on the DEVICE directive is correct, and that your cable 
specification on the UPSCABLE directive is correct.
Apr 15 17:41:27 werner apcupsd[5416]: apcupsd error 
shutdown completed
Apr 15 17:41:45 werner hpijs[5678]: prnt/hpijs/hpijs.cpp 
614: unable to init hpijs server
Apr 15 17:41:47 werner udevd[2740]: add_to_rules: unknown 
key 'MODALIAS' in /etc/udev/rules.d/80-eagle-usb.rules:1
Apr 15 17:42:13 werner kdm_greet[5896]: Can't open default 
user face
Apr 15 17:43:42 werner named[6455]: /etc/named.conf:3: 
option 'multiple-cnames' is obsolete
Apr 15 17:46:20 werner rsyncd[5743]: rsync error: received 
SIGINT, SIGTERM, or SIGHUP (code 20) at rsync.c(554) 
[receiver=3.0.4pre2]
Apr 15 17:47:34 werner kernel: ------------[ cut here 
]------------
Apr 15 17:47:34 werner kernel: WARNING: at 
arch/x86/kernel/pci-nommu.c:64 nommu_map_sg+0x2e/0xe7()
Apr 15 17:47:34 werner kernel: Hardware name: System 
Product Name
Apr 15 17:47:34 werner kernel: Modules linked in: ipv6 
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device 
rt2860sta(C) uvcvideo lp asus_atk0110 rtc_cmos tpm_tis 
rtc_core snd_hda_codec_realtek tpm tpm_bios rtc_lib 
snd_hda_intel 8139too snd_hda_codec snd_hwdep snd_pcm 
snd_timer k8temp snd atl1 soundcore snd_page_alloc 
i2c_nforce2
Apr 15 17:47:34 werner kernel: Pid: 5877, comm: X Tainted: 
G         C  2.6.39-rc3-git4 #1
Apr 15 17:47:34 werner kernel: Call Trace:
Apr 15 17:47:34 werner kernel:  [<c100788a>] ? 
nommu_map_sg+0x2e/0xe7
Apr 15 17:47:34 werner kernel:  [<c103edeb>] 
warn_slowpath_common+0x7a/0x8f
Apr 15 17:47:34 werner kernel:  [<c100788a>] ? 
nommu_map_sg+0x2e/0xe7
Apr 15 17:47:34 werner kernel:  [<c103ee22>] 
warn_slowpath_null+0x22/0x24
Apr 15 17:47:34 werner kernel:  [<c100788a>] 
nommu_map_sg+0x2e/0xe7
Apr 15 17:47:34 werner kernel:  [<c1a28e18>] ? 
ata_rwcmd_protocol+0xb/0x84
Apr 15 17:47:34 werner kernel:  [<c1a29040>] ? 
ata_build_rw_tf+0x1af/0x292
Apr 15 17:47:34 werner kernel:  [<c1a2c095>] 
ata_qc_issue+0x2bc/0x33c
Apr 15 17:47:34 werner kernel:  [<c1a311cc>] 
ata_scsi_translate+0xdd/0x10b
Apr 15 17:47:34 werner kernel:  [<c1a30eaf>] ? 
ata_gen_passthru_sense+0x125/0x125
Apr 15 17:47:34 werner kernel:  [<c1a31ef8>] 
ata_scsi_queuecmd+0x178/0x1bb
Apr 15 17:47:34 werner kernel:  [<c1801b17>] 
scsi_dispatch_cmd+0x164/0x1ee
Apr 15 17:47:34 werner kernel:  [<c15591a0>] ? 
blk_add_timer+0x89/0xab
Apr 15 17:47:34 werner kernel:  [<c1806fcf>] 
scsi_request_fn+0x348/0x483
Apr 15 17:47:34 werner kernel:  [<c1699091>] ? 
mix_pool_bytes_extract+0x10e/0x116
Apr 15 17:47:34 werner kernel:  [<c10f7f8f>] ? 
submit_bh+0xf1/0xf1
Apr 15 17:47:34 werner kernel:  [<c15535c4>] 
__blk_run_queue+0x6c/0xce
Apr 15 17:47:34 werner kernel:  [<c1553ac4>] 
blk_run_queue+0x22/0x33
Apr 15 17:47:34 werner kernel:  [<c18066c6>] 
scsi_run_queue+0x297/0x318
Apr 15 17:47:34 werner kernel:  [<c18072b5>] 
scsi_next_command+0x2d/0x39
Apr 15 17:47:34 werner kernel:  [<c1807de5>] 
scsi_io_completion+0x41f/0x457
Apr 15 17:47:34 werner kernel:  [<c1a19a44>] ? 
sd_done+0xe/0x26d
Apr 15 17:47:34 werner kernel:  [<c18078e6>] ? 
scsi_device_unbusy+0x80/0x86
Apr 15 17:47:34 werner kernel:  [<c1801897>] 
scsi_finish_command+0xce/0xd6
Apr 15 17:47:34 werner kernel:  [<c18049b9>] ? 
scsi_decide_disposition+0xe8/0x16e
Apr 15 17:47:34 werner kernel:  [<c1807f14>] 
scsi_softirq_done+0xe3/0xeb
Apr 15 17:47:34 werner kernel:  [<c10842cf>] ? 
__rcu_process_callbacks+0x6b/0x227
Apr 15 17:47:34 werner kernel:  [<c1558f8f>] 
blk_done_softirq+0x5b/0x68
Apr 15 17:47:34 werner kernel:  [<c1044356>] 
__do_softirq+0xa1/0x169
Apr 15 17:47:34 werner kernel:  [<c16fc040>] ? 
radeon_add_atom_connector+0xbd/0x76f
Apr 15 17:47:34 werner kernel:  [<c10442b5>] ? 
irq_enter+0x4d/0x4d
Apr 15 17:47:34 werner kernel:  <IRQ>  [<c108048c>] ? 
irq_to_desc+0x8/0x1e
Apr 15 17:47:34 werner kernel:  [<c1044164>] ? 
irq_exit+0x37/0x53
Apr 15 17:47:34 werner kernel:  [<c1004715>] ? 
do_IRQ+0x8b/0xa1
Apr 15 17:47:34 werner kernel:  [<c1059b3a>] ? 
__remove_hrtimer+0x5e/0x66
Apr 15 17:47:34 werner kernel:  [<c1dfd750>] ? 
common_interrupt+0x30/0x40
Apr 15 17:47:34 werner kernel:  [<c10e5343>] ? 
poll_select_set_timeout+0x4f/0x62
Apr 15 17:47:34 werner kernel:  [<c10e6518>] ? 
sys_select+0x53/0x96
Apr 15 17:47:34 werner kernel:  [<c1dfc0fc>] ? 
syscall_call+0x7/0xb
Apr 15 17:47:34 werner kernel: ---[ end trace 
2301ca384d9999df ]---
Apr 15 17:47:34 werner kernel: BUG: unable to handle 
kernel NULL pointer dereference at 00000098
Apr 15 17:47:34 werner kernel: IP: [<c1cbee99>] 
sock_wfree+0x12/0x4c
Apr 15 17:47:34 werner kernel: *pde = 00000000
Apr 15 17:47:34 werner kernel: Oops: 0000 [#1] SMP
Apr 15 17:47:34 werner kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:0d.0/boot_vga
Apr 15 17:47:34 werner kernel: Modules linked in: ipv6 
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device 
rt2860sta(C) uvcvideo lp asus_atk0110 rtc_cmos tpm_tis 
rtc_core snd_hda_codec_realtek tpm tpm_bios rtc_lib 
snd_hda_intel 8139too snd_hda_codec snd_hwdep snd_pcm 
snd_timer k8temp snd atl1 soundcore snd_page_alloc 
i2c_nforce2
Apr 15 17:47:34 werner kernel:
Apr 15 17:47:34 werner kernel: Pid: 5984, comm: kded 
Tainted: G        WC  2.6.39-rc3-git4 #1 System 
manufacturer System Product Name/M2N8-VMX
Apr 15 17:47:34 werner kernel: EIP: 0060:[<c1cbee99>] 
EFLAGS: 00010246 CPU: 0
Apr 15 17:47:34 werner kernel: EIP is at 
sock_wfree+0x12/0x4c
Apr 15 17:47:34 werner kernel: EAX: ec79b840 EBX: 00000000 
ECX: ec79b840 EDX: 000002e8
Apr 15 17:47:34 werner kernel: ESI: ec79b840 EDI: ec66fd7c 
EBP: ec66fd50 ESP: ec66fd4c
Apr 15 17:47:34 werner kernel:  DS: 007b ES: 007b FS: 00d8 
GS: 00e0 SS: 0068
Apr 15 17:47:34 werner kernel: Process kded (pid: 5984, 
ti=ec66e000 task=f5c958f0 task.ti=ec66e000)
Apr 15 17:47:34 werner kernel: Stack:
Apr 15 17:47:34 werner kernel:  ec79b840 ec66fd88 c1d37c48 
ec66fd7c ec79b840 00000000 00000000 00000000
Apr 15 17:47:34 werner kernel:  00000000 00000000 00000000 
00000000 ec79b840 ec79b840 ec66fe3c ec66fd94
Apr 15 17:47:34 werner kernel:  c1cc2451 ec79b840 ec66fda0 
c1cc2251 ec79b840 ec66fdb0 c1cc2307 ec79b840
Apr 15 17:47:34 werner kernel: Call Trace:
Apr 15 17:47:34 werner kernel:  [<c1d37c48>] 
unix_destruct_scm+0xa7/0xaf
Apr 15 17:47:34 werner kernel:  [<c1cc2451>] 
skb_release_head_state+0x67/0xb2
Apr 15 17:47:34 werner kernel:  [<c1cc2251>] 
__kfree_skb+0x10/0x72
Apr 15 17:47:34 werner kernel:  [<c1cc2307>] 
consume_skb+0x54/0x58
Apr 15 17:47:34 werner kernel:  [<c1d38d17>] 
unix_stream_recvmsg+0x46b/0x60c
Apr 15 17:47:34 werner kernel:  [<c1523762>] ? 
cap_socket_recvmsg+0x8/0xc
Apr 15 17:47:34 werner kernel:  [<c1cbb215>] 
sock_aio_read+0x131/0x144
Apr 15 17:47:34 werner kernel:  [<c10d7722>] 
do_sync_read+0x98/0xd2
Apr 15 17:47:34 werner kernel:  [<c10d7825>] ? 
rw_verify_area+0xc9/0xeb
Apr 15 17:47:34 werner kernel:  [<c10d8187>] 
vfs_read+0xa4/0x119
Apr 15 17:47:34 werner kernel:  [<c10d85bf>] ? 
fget_light+0xe/0xa1
Apr 15 17:47:34 werner kernel:  [<c10d82a1>] 
sys_read+0x42/0x66
Apr 15 17:47:34 werner kernel:  [<c1dfc0fc>] 
syscall_call+0x7/0xb
Apr 15 17:47:34 werner kernel: Code: ff eb 07 89 d8 e8 a5 
04 41 ff 89 f8 e8 64 b7 3a ff 83 c4 0c 5b 5e 5f 5d c3 55 
89 e5 53 e8 e0 e8 13 00 8b 58 10 8b 90 b0 00 00 00 <8b> 83 
98 00 00 00 f6 c4 02 75 17 8d 42 ff f0 29 83 a4 00 00 00
Apr 15 17:47:34 werner kernel: EIP: [<c1cbee99>] 
sock_wfree+0x12/0x4c SS:ESP 0068:ec66fd4c
Apr 15 17:47:34 werner kernel: CR2: 0000000000000098
Apr 15 17:47:34 werner kernel: ---[ end trace 
2301ca384d9999e0 ]---
Apr 15 17:50:36 werner kernel: ------------[ cut here 
]------------
Apr 15 17:50:36 werner kernel: WARNING: at 
drivers/ata/libata-core.c:5015 ata_qc_issue+0x1ba/0x33c()
Apr 15 17:50:36 werner kernel: Hardware name: System 
Product Name
Apr 15 17:50:36 werner kernel: Modules linked in: ipv6 
snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device 
rt2860sta(C) uvcvideo lp asus_atk0110 rtc_cmos tpm_tis 
rtc_core snd_hda_codec_realtek tpm tpm_bios rtc_lib 
snd_hda_intel 8139too snd_hda_codec snd_hwdep snd_pcm 
snd_timer k8temp snd atl1 soundcore snd_page_alloc 
i2c_nforce2
Apr 15 17:50:36 werner kernel: Pid: 7997, comm: removepkg 
Tainted: G      D WC  2.6.39-rc3-git4 #1
Apr 15 17:50:36 werner kernel: Call Trace:
Apr 15 17:50:36 werner kernel:  [<c1a2bf93>] ? 
ata_qc_issue+0x1ba/0x33c
Apr 15 17:50:36 werner kernel:  [<c103edeb>] 
warn_slowpath_common+0x7a/0x8f
Apr 15 17:50:36 werner kernel:  [<c1a2bf93>] ? 
ata_qc_issue+0x1ba/0x33c
Apr 15 17:50:36 werner kernel:  [<c103ee22>] 
warn_slowpath_null+0x22/0x24
Apr 15 17:50:36 werner kernel:  [<c1a2bf93>] 
ata_qc_issue+0x1ba/0x33c
Apr 15 17:50:36 werner kernel:  [<c1a311cc>] 
ata_scsi_translate+0xdd/0x10b
Apr 15 17:50:36 werner kernel:  [<c1a30eaf>] ? 
ata_gen_passthru_sense+0x125/0x125
Apr 15 17:50:36 werner kernel:  [<c1a31ef8>] 
ata_scsi_queuecmd+0x178/0x1bb
Apr 15 17:50:36 werner kernel:  [<c1801b17>] 
scsi_dispatch_cmd+0x164/0x1ee
Apr 15 17:50:36 werner kernel:  [<c15591a0>] ? 
blk_add_timer+0x89/0xab
Apr 15 17:50:36 werner kernel:  [<c1806fcf>] 
scsi_request_fn+0x348/0x483
Apr 15 17:50:36 werner kernel:  [<c15535c4>] 
__blk_run_queue+0x6c/0xce
Apr 15 17:50:36 werner kernel:  [<c1553ac4>] 
blk_run_queue+0x22/0x33
Apr 15 17:50:36 werner kernel:  [<c18066c6>] 
scsi_run_queue+0x297/0x318
Apr 15 17:50:36 werner kernel:  [<c18072b5>] 
scsi_next_command+0x2d/0x39
Apr 15 17:50:36 werner kernel:  [<c1807de5>] 
scsi_io_completion+0x41f/0x457
Apr 15 17:50:36 werner kernel:  [<c1a19a44>] ? 
sd_done+0xe/0x26d
Apr 15 17:50:36 werner kernel:  [<c1cc9a1d>] ? 
__netif_receive_skb+0x428/0x451
Apr 15 17:50:36 werner kernel:  [<c18078e6>] ? 
scsi_device_unbusy+0x80/0x86
Apr 15 17:50:36 werner kernel:  [<c1801897>] 
scsi_finish_command+0xce/0xd6
Apr 15 17:50:36 werner kernel:  [<c18049b9>] ? 
scsi_decide_disposition+0xe8/0x16e
Apr 15 17:50:36 werner kernel:  [<c1807f14>] 
scsi_softirq_done+0xe3/0xeb
Apr 15 17:50:36 werner kernel:  [<c10842cf>] ? 
__rcu_process_callbacks+0x6b/0x227
Apr 15 17:50:36 werner kernel:  [<c1558f8f>] 
blk_done_softirq+0x5b/0x68
Apr 15 17:50:36 werner kernel:  [<c1044356>] 
__do_softirq+0xa1/0x169
Apr 15 17:50:36 werner kernel:  [<c16fc040>] ? 
radeon_add_atom_connector+0xbd/0x76f
Apr 15 17:50:36 werner kernel:  [<c10442b5>] ? 
irq_enter+0x4d/0x4d
Apr 15 17:50:36 werner kernel:  <IRQ>  [<c108048c>] ? 
irq_to_desc+0x8/0x1e
Apr 15 17:50:36 werner kernel:  [<c1044164>] ? 
irq_exit+0x37/0x53
Apr 15 17:50:36 werner kernel:  [<c1004715>] ? 
do_IRQ+0x8b/0xa1
Apr 15 17:50:36 werner kernel:  [<c10e8d1a>] ? 
dput+0x2d/0x1ce
Apr 15 17:50:36 werner kernel:  [<c105be81>] ? 
current_user_ns+0x8/0x1c
Apr 15 17:50:36 werner kernel:  [<c10df35d>] ? 
acl_permission_check+0x1f/0x8d
Apr 15 17:50:36 werner kernel:  [<c1dfd750>] ? 
common_interrupt+0x30/0x40
Apr 15 17:50:36 werner kernel:  [<c1dfbd21>] ? 
_raw_spin_lock+0x12/0x1e
Apr 15 17:50:36 werner kernel:  [<c10e8d1a>] ? 
dput+0x2d/0x1ce
Apr 15 17:50:36 werner kernel:  [<c10e21fb>] ? 
path_lookupat+0x24e/0x6d0
Apr 15 17:50:36 werner kernel:  [<c10cef91>] ? 
kmem_cache_alloc+0x2a/0xed
Apr 15 17:50:36 werner kernel:  [<c10e26bb>] ? 
do_path_lookup+0x3e/0x9d
Apr 15 17:50:36 werner kernel:  [<c10e3410>] ? 
user_path_at+0x45/0x6a
Apr 15 17:50:36 werner kernel:  [<c10b935e>] ? 
handle_mm_fault+0x1d9/0x1ec
Apr 15 17:50:36 werner kernel:  [<c10db0a3>] ? 
vfs_fstatat+0x4a/0x71
Apr 15 17:50:36 werner kernel:  [<c10db1c9>] ? 
vfs_stat+0x20/0x22
Apr 15 17:50:36 werner kernel:  [<c10db1e4>] ? 
sys_stat64+0x19/0x2d
Apr 15 17:50:36 werner kernel:  [<c104ae7f>] ? 
recalc_sigpending+0x17/0x3b
Apr 15 17:50:36 werner kernel:  [<c1dfa8be>] ? 
_cond_resched+0x8/0x47
Apr 15 17:50:36 werner kernel:  [<c156a5aa>] ? 
copy_to_user+0x2d/0x58
Apr 15 17:50:36 werner kernel:  [<c104c077>] ? 
sys_rt_sigprocmask+0xa5/0xb9
Apr 15 17:50:36 werner kernel:  [<c1dfc0fc>] ? 
syscall_call+0x7/0xb
Apr 15 17:50:36 werner kernel: ---[ end trace 
2301ca384d9999e1 ]---
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:4e:00:7c/00:00:35:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
Apr 15 17:50:36 werner kernel: ata1.00: exception Emask 
0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 15 17:50:36 werner kernel: ata1.00: failed command: 
WRITE DMA EXT
Apr 15 17:50:36 werner kernel: ata1.00: cmd 
35/00:30:57:06:7c/00:00:35:00:00/e0 tag 0 dma 24576 out
Apr 15 17:50:36 werner kernel:          res 
50/00:00:af:88:e0/00:00:e8:00:00/e0 Emask 0x40 (internal 
error)
Apr 15 17:50:36 werner kernel: ata1.00: status: { DRDY }
---
Professional hosting for everyone - http://www.host.ru

