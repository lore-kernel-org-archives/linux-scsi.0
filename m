From: Olaf Hering <olh@suse.de>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Sat, 2 Oct 2004 18:38:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002163810.GA8671@suse.de>
References: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:7055 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267375AbUJBQiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2004 12:38:13 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

 On Mon, Sep 20, James.Smart@Emulex.Com wrote:

> Christoph,
> 
> FYI - the 8.0.12 lpfc driver has been posted to SourceForge.

James,

I tried it on a legacy iseries partition, there where a few
warnings/errors in dmesg. the box has no storage attached. Does that
indicate a driver problem, or is it just the not-attached storage?

On rmmod, the partition died:

curry:~ # rmmod lpfc
Kernel panic - not syncing: PCI: Hardware I/O Error, SRC B6000103, Automatic Reboot Disabled.

this is 2.6.9-rc3-bk2, + bk-scsi-target.patch and bk-scsi.patch with
arch/ppc64/configs/iseriesconfig.


-- 
USB is for mice, FireWire is for men!

sUse lINUX ag, nÜRNBERG

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.txt"

D-cache line size = 128
I-cache line size = 128
Mapping load area - physical addr = 0000000000000000
                    absolute addr = 0000000015000000
Load area size 32768K
HPT absolute addr = 0000000024000000, size = 16384K
Mainstore_VPD: Condor
Mainstore_VPD: numMemoryBlocks = 1 
Mainstore_VPD: block   0 logical chunks 0000000000000000 - 0000000100000000
                             abs chunks 0000000000000000 - 0000000100000000
mf.c: iSeries Linux LPAR Machine Facilities initialized
Starting Linux PPC64 2.6.9-rc3-bk2-iseries
-----------------------------------------------------
naca                          = 0xc000000000004000
naca->pftSize                 = 0x0
naca->debug_switch            = 0x0
naca->interrupt_controller    = 0x0
systemcfg                     = 0xc000000000005000
systemcfg->processorCount     = 0x1
systemcfg->physicalMemorySize = 0x1f000000
systemcfg->dCacheL1LineSize   = 0x80
systemcfg->iCacheL1LineSize   = 0x80
htab_data.htab                = 0x0000000000000000
htab_data.num_ptegs           = 0x20000
-----------------------------------------------------
Progress: [0000] - cf000100        

Progress: [0000] - MM Init         
[boot]0100 MM Init
Progress: [0000] - cf000100        

Progress: [0000] - MM Init Done    
[boot]0100 MM Init Done
Linux version 2.6.9-rc3-bk2-iseries (olaf@pomegranate) (gcc version 3.3.3 (SuSE Linux)) #6 SMP Sat Oct 2 18:21:53 CEST 2004
Progress: [0000] - cf000012        

Progress: [0000] - Setup Arch      
[boot]0012 Setup Arch
Max  logical processors = 64
Max physical processors = 32
Processor frequency = 601.60
Time base frequency = 601.60
Processor version = 370000
Top of RAM: 0x1f000000, Total RAM: 0x1f000000
Memory hole size: 0MB
On node 0 totalpages: 126976
  DMA zone: 126976 pages, LIFO batch:16
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
Progress: [0000] - cf000015        

Progress: [0000] - Setup Done      
[boot]0015 Setup Done
Built 1 zonelists
Kernel command line: root=/dev/iseries/vdf3 hwinfo=-cdrom selinux=0 elevator=cfq
PID hash table entries: 2048 (order: 11, 65536 bytes)
viocons: registering console
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Memory: 491136k/507904k available (3012k kernel code, 16424k reserved, 1360k data, 359k bss, 152k init)
IOMMU table initialized, virtual merging enabled
Calibrating delay loop... 1196.03 BogoMIPS (lpj=598016)
Mount-cache hash table entries: 256 (order: 0, 4096 bytes)
Brought up 1 CPUs
checking if image is initramfs... it is
Freeing initrd memory: 1192k freed
NET: Registered protocol family 16
bus 24 appears to exist
found device at bus 24 idsel 1 func 2 (AgentId 12)
bridge info: type 4 subbus 28 maxAgents 1 maxsubbus 0 logslot 0
read vendor ID: 10df
PCI: Probing PCI hardware
pcibios_final_fixup
pci dev c00000000101c800 (18.90), node c00000001eff8980
1. PCI: Bus 24, Device 18, Vendor 10DF Frame  2, Card  C06  Fibre Channel
PCI: Probing PCI hardware done
SCSI subsystem initialized
audit: initializing netlink socket (disabled)
audit(1101028958.779:0): initialized
Initializing Cryptographic API
viopath: opening connection to partition 0, setting sinst 32772, tinst 32769
viocons: hosting partition 0
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
viod: vers 1.64, hosting partition 0
vio_register_driver: driver viodasd registering
Using cfq io scheduler
viod: disk 0: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vda: iseries/vda1
viod: disk 1: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdb: iseries/vdb1
viod: disk 2: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdc: iseries/vdc1
viod: disk 3: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdd: iseries/vdd1
viod: disk 4: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vde: iseries/vde1
viod: disk 5: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdf: iseries/vdf1 iseries/vdf2 iseries/vdf3
viod: disk 6: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdg: unknown partition table
viod: disk 7: 4096575 sectors (2000 MB) CHS=255/255/63 sector size 512
 iseries/vdh: iseries/vdh1 iseries/vdh2 iseries/vdh3
viod: disk 8: 2048 sectors (1 MB) CHS=1/64/32 sector size 512
 iseries/vdi: unknown partition table
viod: disk 9: 2048 sectors (1 MB) CHS=1/64/32 sector size 512
 iseries/vdj: unknown partition table
viod: disk 10: 2048 sectors (1 MB) CHS=1/64/32 sector size 512
 iseries/vdk: unknown partition table
viod: disk 11: 2048 sectors (1 MB) CHS=1/64/32 sector size 512
 iseries/vdl: unknown partition table
viod: disk 12: 524288 sectors (256 MB) CHS=256/64/32 sector size 512
 iseries/vdm: iseries/vdm1
viod: disk 13: 524288 sectors (256 MB) CHS=256/64/32 sector size 512
 iseries/vdn: unknown partition table
viod: disk 14: 524288 sectors (256 MB) CHS=256/64/32 sector size 512
 iseries/vdo: unknown partition table
viod: disk 15: 524288 sectors (256 MB) CHS=256/64/32 sector size 512
 iseries/vdp: unknown partition table
pcnet32.c:v1.30i 06.28.2004 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.0.27-k2-NAPI
e100: Copyright(c) 1999-2004 Intel Corporation
vio_register_driver: driver iseries_veth registering
/home/olaf/kernel/ppc64-nonet/linux-2.6.9-rc3-bk2.iseries/drivers/net/iseries_veth.c: eth0 attached to iSeries vlan 0 (lpar_map=0x001b)
/home/olaf/kernel/ppc64-nonet/linux-2.6.9-rc3-bk2.iseries/drivers/net/iseries_veth.c: eth1 attached to iSeries vlan 1 (lpar_map=0x001a)
/home/olaf/kernel/ppc64-nonet/linux-2.6.9-rc3-bk2.iseries/drivers/net/iseries_veth.c: eth2 attached to iSeries vlan 3 (lpar_map=0x0010)
netconsole: not configured, aborting
st: Version 20040403, fixed bufsize 32768, s/g segs 256
mice: PS/2 mouse device common for all mice
md: linear personality registered as nr 1
md: raid0 personality registered as nr 2
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :   976.000 MB/sec
   8regs_prefetch:   884.000 MB/sec
   32regs    :  1312.000 MB/sec
   32regs_prefetch:  1116.000 MB/sec
raid5: using function: 32regs (1312.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
oprofile: using ppc64/rs64 performance monitoring.
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 32Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
IPv4 over IPv4 tunneling driver
NET: Registered protocol family 1
NET: Registered protocol family 17
Progress: [ffff] -  
Freeing unused kernel memory: 152k freed
ReiserFS: iseries/vdf3: found reiserfs format "3.6" with standard journal
ReiserFS: iseries/vdf3: using ordered data mode
ReiserFS: iseries/vdf3: journal params: device iseries/vdf3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: iseries/vdf3: checking transaction log (iseries/vdf3)
ReiserFS: iseries/vdf3: Using r5 hash to sort names
ioctl32(showconsole:1324): Unknown cmd fd(0) cmd(40045432){00} arg(ffffea78) on /dev/console
Adding 248996k swap on /dev/iseries/vdf2.  Priority:42 extents:1
Adding 248996k swap on /dev/iseries/vdh2.  Priority:42 extents:1
Adding 262120k swap on /dev/iseries/vdm1.  Priority:42 extents:1
ioctl32(showconsole:1422): Unknown cmd fd(0) cmd(40045432){00} arg(ffffe9d8) on /dev/console
md: Autodetecting RAID arrays.
md: autorun ...
md: considering iseries/vdc1 ...
md:  adding iseries/vdc1 ...
md:  adding iseries/vdb1 ...
md:  adding iseries/vda1 ...
md: created md0
md: bind<iseries/vda1>
md: bind<iseries/vdb1>
md: bind<iseries/vdc1>
md: running: <iseries/vdc1><iseries/vdb1><iseries/vda1>
raid5: device iseries/vdc1 operational as raid disk 2
raid5: device iseries/vdb1 operational as raid disk 1
raid5: device iseries/vda1 operational as raid disk 0
raid5: allocated 3210kB for md0
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, o:1, dev:iseries/vda1
 disk 1, o:1, dev:iseries/vdb1
 disk 2, o:1, dev:iseries/vdc1
md: ... autorun DONE.
ioctl32(showconsole:1498): Unknown cmd fd(0) cmd(40045432){00} arg(ffffea08) on /dev/console
ioctl32(showconsole:1557): Unknown cmd fd(0) cmd(40045432){00} arg(ffffea18) on /dev/console
Titan recalibrate: new tb_ticks_per_jiffy = 601586 (-14)
ioctl32(showconsole:1707): Unknown cmd fd(0) cmd(40045432){00} arg(ffffea58) on /dev/console
Emulex LightPulse Fibre Channel SCSI driver 8.0.12
PCI: Enabling device: (0000:18:12.0), cmd 3
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
lpfc 0000:18:12.0: 0:0321 Unknown IOCB command Data: x0 x3 x0 x0
ioctl32(hwscan:2586): Unknown cmd fd(3) cmd(40045432){00} arg(ffffe804) on /dev/console
scsi0 : Emulex LightPulse LP9002 2 Gigabit PCI Fibre Channel Adapter on PCI bus 18 device 90 irq 2

--ReaqsoxgOBHFXBhH--
