From: Olaf Hering <olh@suse.de>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 15:29:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824132936.GA25263@suse.de>
References: <1093113450.1732.334.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:9405 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267795AbUHXN3m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 09:29:42 -0400
Content-Disposition: inline
In-Reply-To: <1093113450.1732.334.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

 On Sat, Aug 21, James Bottomley wrote:

> The problems with domain validation were just the tip of the iceberg =
in
> the sym2 driver.  Most of its problems seem to come from an overly
> complex set of negotiating rules, which I've swept away with this pat=
ch.

I see timeouts on the CDROM during boot with 2.6.8, they do not happen
with our 2.6.5 based SLES9 kernel. This patch doesnt fix it, no idea if
it was supposed to fix this sort of error.

PCI: Enabling device: (0003:61:01.0), cmd 143
sym1: <875> rev 0x3 at pci 0003:61:01.0 irq 86
sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.1.18j
sym1:5:0: ABORT operation started.
sym1:5:0: ABORT operation timed-out.
sym1:5:0: DEVICE RESET operation started.
sym1:5:0: DEVICE RESET operation complete.
sym1:5:control msgout: c.
sym1: TARGET 5 has been reset.
sym1:5:0: ABORT operation started.
sym1:5:0: ABORT operation complete.
sym1:5:0: BUS RESET operation started.
sym1:5:0: BUS RESET operation complete.
sym1: SCSI BUS reset detected.
sym1: SCSI BUS has been reset.
  Vendor: IBM       Model: DROM00203         Rev: 7R41
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi(1:0:5:0): Beginning Domain Validation
sym1:5: wide asynchronous.
sym1:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 14)
scsi(1:0:5:0): Domain Validation skipping write tests
scsi(1:0:5:0): Ending Domain Validation
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
Attached scsi CD-ROM sr0 at scsi1, channel 0, id 5, lun 0
sym1:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: HP        Model: IBM-C568303030!D  Rev: C209
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi(1:0:6:0): Beginning Domain Validation
sym1:6: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
sym1:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
scsi(1:0:6:0): Domain Validation skipping write tests
scsi(1:0:6:0): Ending Domain Validation

=2E..


firmware_features =3D 0xd7f
Starting Linux PPC64 2.6.9-rc1-tst-timer4
-----------------------------------------------------
naca                          =3D 0xc000000000004000
naca->pftSize                 =3D 0x1c
naca->debug_switch            =3D 0x0
naca->interrupt_controller    =3D 0x2
systemcfg                     =3D 0xc000000000005000
systemcfg->processorCount     =3D 0xc
systemcfg->physicalMemorySize =3D 0x210000000
systemcfg->dCacheL1LineSize   =3D 0x80
systemcfg->iCacheL1LineSize   =3D 0x80
htab_data.htab                =3D 0x0000000000000000
htab_data.num_ptegs           =3D 0x200000
-----------------------------------------------------
[boot]0100 MM Init
[boot]0100 MM Init Done
idle =3D default_idle
Linux version 2.6.9-rc1-tst-timer4 (olaf@pomegranate) (gcc version 3.3.=
3 (SuSE Linux)) #1 SMP Tue Aug 24 14:09:52 CEST 2004
[boot]0012 Setup Arch
WARNING: could not find NUMA associativity reference point
NUMA associativity depth for CPU/Memory: -1
Top of RAM: 0x210000000, Total RAM: 0x210000000
Memory hole size: 0MB
cpu 0 maps to domain 0
cpu 1 maps to domain 0
cpu 2 maps to domain 0
cpu 3 maps to domain 0
cpu 4 maps to domain 0
cpu 5 maps to domain 0
cpu 6 maps to domain 0
cpu 7 maps to domain 0
cpu 8 maps to domain 0
cpu 9 maps to domain 0
cpu 10 maps to domain 0
cpu 11 maps to domain 0
cpu 12 maps to domain 0
cpu 13 maps to domain 0
cpu 14 maps to domain 0
cpu 15 maps to domain 0
cpu 16 maps to domain 0
cpu 17 maps to domain 0
cpu 18 maps to domain 0
cpu 19 maps to domain 0
cpu 20 maps to domain 0
cpu 21 maps to domain 0
cpu 22 maps to domain 0
cpu 23 maps to domain 0
cpu 24 maps to domain 0
cpu 25 maps to domain 0
cpu 26 maps to domain 0
cpu 27 maps to domain 0
cpu 28 maps to domain 0
cpu 29 maps to domain 0
cpu 30 maps to domain 0
cpu 31 maps to domain 0
cpu 32 maps to domain 0
cpu 33 maps to domain 0
cpu 34 maps to domain 0
cpu 35 maps to domain 0
cpu 36 maps to domain 0
cpu 37 maps to domain 0
cpu 38 maps to domain 0
cpu 39 maps to domain 0
cpu 40 maps to domain 0
cpu 41 maps to domain 0
cpu 42 maps to domain 0
cpu 43 maps to domain 0
cpu 44 maps to domain 0
cpu 45 maps to domain 0
cpu 46 maps to domain 0
cpu 47 maps to domain 0
cpu 48 maps to domain 0
cpu 49 maps to domain 0
cpu 50 maps to domain 0
cpu 51 maps to domain 0
cpu 52 maps to domain 0
cpu 53 maps to domain 0
cpu 54 maps to domain 0
cpu 55 maps to domain 0
cpu 56 maps to domain 0
cpu 57 maps to domain 0
cpu 58 maps to domain 0
cpu 59 maps to domain 0
cpu 60 maps to domain 0
cpu 61 maps to domain 0
cpu 62 maps to domain 0
cpu 63 maps to domain 0
cpu 64 maps to domain 0
cpu 65 maps to domain 0
cpu 66 maps to domain 0
cpu 67 maps to domain 0
cpu 68 maps to domain 0
cpu 69 maps to domain 0
cpu 70 maps to domain 0
cpu 71 maps to domain 0
cpu 72 maps to domain 0
cpu 73 maps to domain 0
cpu 74 maps to domain 0
cpu 75 maps to domain 0
cpu 76 maps to domain 0
cpu 77 maps to domain 0
cpu 78 maps to domain 0
cpu 79 maps to domain 0
cpu 80 maps to domain 0
cpu 81 maps to domain 0
cpu 82 maps to domain 0
cpu 83 maps to domain 0
cpu 84 maps to domain 0
cpu 85 maps to domain 0
cpu 86 maps to domain 0
cpu 87 maps to domain 0
cpu 88 maps to domain 0
cpu 89 maps to domain 0
cpu 90 maps to domain 0
cpu 91 maps to domain 0
cpu 92 maps to domain 0
cpu 93 maps to domain 0
cpu 94 maps to domain 0
cpu 95 maps to domain 0
cpu 96 maps to domain 0
cpu 97 maps to domain 0
cpu 98 maps to domain 0
cpu 99 maps to domain 0
cpu 100 maps to domain 0
cpu 101 maps to domain 0
cpu 102 maps to domain 0
cpu 103 maps to domain 0
cpu 104 maps to domain 0
cpu 105 maps to domain 0
cpu 106 maps to domain 0
cpu 107 maps to domain 0
cpu 108 maps to domain 0
cpu 109 maps to domain 0
cpu 110 maps to domain 0
cpu 111 maps to domain 0
cpu 112 maps to domain 0
cpu 113 maps to domain 0
cpu 114 maps to domain 0
cpu 115 maps to domain 0
cpu 116 maps to domain 0
cpu 117 maps to domain 0
cpu 118 maps to domain 0
cpu 119 maps to domain 0
cpu 120 maps to domain 0
cpu 121 maps to domain 0
cpu 122 maps to domain 0
cpu 123 maps to domain 0
cpu 124 maps to domain 0
cpu 125 maps to domain 0
cpu 126 maps to domain 0
cpu 127 maps to domain 0
node 0
start_paddr =3D 0
end_paddr =3D 210000000
bootmap_pages =3D 42
bootmap_paddr =3D 20ffbc000
free_bootmem 0 210000000
reserve_bootmem 0 879b60
reserve_bootmem 4400000 154000
reserve_bootmem f92c000 6d4000
reserve_bootmem 20ffbc000 42000
reserve_bootmem 20fffef08 10f8
Boot arguments: root=3D/dev/sdb3 desktop selinux=3D0 elevator=3Dcfq spl=
ash=3Dsilent=20
RTAS: event: 1, Type: Internal Device Failure, Severity: 5
RTAS: event: 2, Type: Internal Device Failure, Severity: 5
RTAS: event: 3, Type: Internal Device Failure, Severity: 5
RTAS: event: 4, Type: Internal Device Failure, Severity: 5
RTAS: event: 5, Type: Internal Device Failure, Severity: 5
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 22528 bytes
free_area_init node 0 210000 0 (hole: 0)
On node 0 totalpages: 2162688
  DMA zone: 2162688 pages, LIFO batch:16
  Normal zone: 0 pages, LIFO batch:1
  HighMem zone: 0 pages, LIFO batch:1
[boot]0015 Setup Done
Built 1 zonelists
Kernel command line: root=3D/dev/sdb3 desktop selinux=3D0 elevator=3Dcf=
q splash=3Dsilent=20
[boot]0020 XICS Init
[boot]0021 XICS Done
PID hash table entries: 4096 (order 12: 65536 bytes)
time_init: decrementer frequency =3D 137.495999 MHz
time_init: processor frequency   =3D 1099.967992 MHz
Console: colour dummy device 80x25
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
freeing bootmem node 0
Memory: 8485760k available (0k kernel code, 0k data, 0k init) [c0000000=
00000000,c000000210000000]
Calibrating delay loop... 274.43 BogoMIPS
Security Scaffold v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256 (order: 0, 4096 bytes)
Partition configured for 16 cpus.
Processor 1 found.
Processor 2 found.
Processor 3 found.
Processor 4 found.
Processor 5 found.
Processor 6 found.
Processor 7 found.
Processor 8 found.
Processor 9 found.
Processor 10 found.
Processor 11 found.
Brought up 12 CPUs
CPU0:  online
 domain 0: span 00000000,00000000,00000000,00000001
  groups: 00000000,00000000,00000000,00000001
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000001 00000000,00000000,000000=
00,00000002 00000000,00000000,00000000,00000004 00000000,00000000,00000=
000,00000008 00000000,00000000,00000000,00000010 00000000,00000000,0000=
0000,00000020 00000000,00000000,00000000,00000040 00000000,00000000,000=
00000,00000080 00000000,00000000,00000000,00000100 00000000,00000000,00=
000000,00000200 00000000,00000000,00000000,00000400 00000000,00000000,0=
0000000,00000800 00000000,00000000,00000000,00001000 00000000,00000000,=
00000000,00002000 00000000,00000000,00000000,00004000 00000000,00000000=
,00000000,00008000
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU1:  online
 domain 0: span 00000000,00000000,00000000,00000002
  groups: 00000000,00000000,00000000,00000002
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000002 00000000,00000000,000000=
00,00000004 00000000,00000000,00000000,00000008 00000000,00000000,00000=
000,00000010 00000000,00000000,00000000,00000020 00000000,00000000,0000=
0000,00000040 00000000,00000000,00000000,00000080 00000000,00000000,000=
00000,00000100 00000000,00000000,00000000,00000200 00000000,00000000,00=
000000,00000400 00000000,00000000,00000000,00000800 00000000,00000000,0=
0000000,00001000 00000000,00000000,00000000,00002000 00000000,00000000,=
00000000,00004000 00000000,00000000,00000000,00008000 00000000,00000000=
,00000000,00000001
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU2:  online
 domain 0: span 00000000,00000000,00000000,00000004
  groups: 00000000,00000000,00000000,00000004
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000004 00000000,00000000,000000=
00,00000008 00000000,00000000,00000000,00000010 00000000,00000000,00000=
000,00000020 00000000,00000000,00000000,00000040 00000000,00000000,0000=
0000,00000080 00000000,00000000,00000000,00000100 00000000,00000000,000=
00000,00000200 00000000,00000000,00000000,00000400 00000000,00000000,00=
000000,00000800 00000000,00000000,00000000,00001000 00000000,00000000,0=
0000000,00002000 00000000,00000000,00000000,00004000 00000000,00000000,=
00000000,00008000 00000000,00000000,00000000,00000001 00000000,00000000=
,00000000,00000002
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU3:  online
 domain 0: span 00000000,00000000,00000000,00000008
  groups: 00000000,00000000,00000000,00000008
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000008 00000000,00000000,000000=
00,00000010 00000000,00000000,00000000,00000020 00000000,00000000,00000=
000,00000040 00000000,00000000,00000000,00000080 00000000,00000000,0000=
0000,00000100 00000000,00000000,00000000,00000200 00000000,00000000,000=
00000,00000400 00000000,00000000,00000000,00000800 00000000,00000000,00=
000000,00001000 00000000,00000000,00000000,00002000 00000000,00000000,0=
0000000,00004000 00000000,00000000,00000000,00008000 00000000,00000000,=
00000000,00000001 00000000,00000000,00000000,00000002 00000000,00000000=
,00000000,00000004
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU4:  online
 domain 0: span 00000000,00000000,00000000,00000010
  groups: 00000000,00000000,00000000,00000010
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000010 00000000,00000000,000000=
00,00000020 00000000,00000000,00000000,00000040 00000000,00000000,00000=
000,00000080 00000000,00000000,00000000,00000100 00000000,00000000,0000=
0000,00000200 00000000,00000000,00000000,00000400 00000000,00000000,000=
00000,00000800 00000000,00000000,00000000,00001000 00000000,00000000,00=
000000,00002000 00000000,00000000,00000000,00004000 00000000,00000000,0=
0000000,00008000 00000000,00000000,00000000,00000001 00000000,00000000,=
00000000,00000002 00000000,00000000,00000000,00000004 00000000,00000000=
,00000000,00000008
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU5:  online
 domain 0: span 00000000,00000000,00000000,00000020
  groups: 00000000,00000000,00000000,00000020
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000020 00000000,00000000,000000=
00,00000040 00000000,00000000,00000000,00000080 00000000,00000000,00000=
000,00000100 00000000,00000000,00000000,00000200 00000000,00000000,0000=
0000,00000400 00000000,00000000,00000000,00000800 00000000,00000000,000=
00000,00001000 00000000,00000000,00000000,00002000 00000000,00000000,00=
000000,00004000 00000000,00000000,00000000,00008000 00000000,00000000,0=
0000000,00000001 00000000,00000000,00000000,00000002 00000000,00000000,=
00000000,00000004 00000000,00000000,00000000,00000008 00000000,00000000=
,00000000,00000010
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU6:  online
 domain 0: span 00000000,00000000,00000000,00000040
  groups: 00000000,00000000,00000000,00000040
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000040 00000000,00000000,000000=
00,00000080 00000000,00000000,00000000,00000100 00000000,00000000,00000=
000,00000200 00000000,00000000,00000000,00000400 00000000,00000000,0000=
0000,00000800 00000000,00000000,00000000,00001000 00000000,00000000,000=
00000,00002000 00000000,00000000,00000000,00004000 00000000,00000000,00=
000000,00008000 00000000,00000000,00000000,00000001 00000000,00000000,0=
0000000,00000002 00000000,00000000,00000000,00000004 00000000,00000000,=
00000000,00000008 00000000,00000000,00000000,00000010 00000000,00000000=
,00000000,00000020
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU7:  online
 domain 0: span 00000000,00000000,00000000,00000080
  groups: 00000000,00000000,00000000,00000080
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000080 00000000,00000000,000000=
00,00000100 00000000,00000000,00000000,00000200 00000000,00000000,00000=
000,00000400 00000000,00000000,00000000,00000800 00000000,00000000,0000=
0000,00001000 00000000,00000000,00000000,00002000 00000000,00000000,000=
00000,00004000 00000000,00000000,00000000,00008000 00000000,00000000,00=
000000,00000001 00000000,00000000,00000000,00000002 00000000,00000000,0=
0000000,00000004 00000000,00000000,00000000,00000008 00000000,00000000,=
00000000,00000010 00000000,00000000,00000000,00000020 00000000,00000000=
,00000000,00000040
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU8:  online
 domain 0: span 00000000,00000000,00000000,00000100
  groups: 00000000,00000000,00000000,00000100
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000100 00000000,00000000,000000=
00,00000200 00000000,00000000,00000000,00000400 00000000,00000000,00000=
000,00000800 00000000,00000000,00000000,00001000 00000000,00000000,0000=
0000,00002000 00000000,00000000,00000000,00004000 00000000,00000000,000=
00000,00008000 00000000,00000000,00000000,00000001 00000000,00000000,00=
000000,00000002 00000000,00000000,00000000,00000004 00000000,00000000,0=
0000000,00000008 00000000,00000000,00000000,00000010 00000000,00000000,=
00000000,00000020 00000000,00000000,00000000,00000040 00000000,00000000=
,00000000,00000080
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU9:  online
 domain 0: span 00000000,00000000,00000000,00000200
  groups: 00000000,00000000,00000000,00000200
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000200 00000000,00000000,000000=
00,00000400 00000000,00000000,00000000,00000800 00000000,00000000,00000=
000,00001000 00000000,00000000,00000000,00002000 00000000,00000000,0000=
0000,00004000 00000000,00000000,00000000,00008000 00000000,00000000,000=
00000,00000001 00000000,00000000,00000000,00000002 00000000,00000000,00=
000000,00000004 00000000,00000000,00000000,00000008 00000000,00000000,0=
0000000,00000010 00000000,00000000,00000000,00000020 00000000,00000000,=
00000000,00000040 00000000,00000000,00000000,00000080 00000000,00000000=
,00000000,00000100
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU10:  online
 domain 0: span 00000000,00000000,00000000,00000400
  groups: 00000000,00000000,00000000,00000400
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000400 00000000,00000000,000000=
00,00000800 00000000,00000000,00000000,00001000 00000000,00000000,00000=
000,00002000 00000000,00000000,00000000,00004000 00000000,00000000,0000=
0000,00008000 00000000,00000000,00000000,00000001 00000000,00000000,000=
00000,00000002 00000000,00000000,00000000,00000004 00000000,00000000,00=
000000,00000008 00000000,00000000,00000000,00000010 00000000,00000000,0=
0000000,00000020 00000000,00000000,00000000,00000040 00000000,00000000,=
00000000,00000080 00000000,00000000,00000000,00000100 00000000,00000000=
,00000000,00000200
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU11:  online
 domain 0: span 00000000,00000000,00000000,00000800
  groups: 00000000,00000000,00000000,00000800
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00000800 00000000,00000000,000000=
00,00001000 00000000,00000000,00000000,00002000 00000000,00000000,00000=
000,00004000 00000000,00000000,00000000,00008000 00000000,00000000,0000=
0000,00000001 00000000,00000000,00000000,00000002 00000000,00000000,000=
00000,00000004 00000000,00000000,00000000,00000008 00000000,00000000,00=
000000,00000010 00000000,00000000,00000000,00000020 00000000,00000000,0=
0000000,00000040 00000000,00000000,00000000,00000080 00000000,00000000,=
00000000,00000100 00000000,00000000,00000000,00000200 00000000,00000000=
,00000000,00000400
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU12: offline
 domain 0: span 00000000,00000000,00000000,00001000
  groups: 00000000,00000000,00000000,00001000
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00001000 00000000,00000000,000000=
00,00002000 00000000,00000000,00000000,00004000 00000000,00000000,00000=
000,00008000 00000000,00000000,00000000,00000001 00000000,00000000,0000=
0000,00000002 00000000,00000000,00000000,00000004 00000000,00000000,000=
00000,00000008 00000000,00000000,00000000,00000010 00000000,00000000,00=
000000,00000020 00000000,00000000,00000000,00000040 00000000,00000000,0=
0000000,00000080 00000000,00000000,00000000,00000100 00000000,00000000,=
00000000,00000200 00000000,00000000,00000000,00000400 00000000,00000000=
,00000000,00000800
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU13: offline
 domain 0: span 00000000,00000000,00000000,00002000
  groups: 00000000,00000000,00000000,00002000
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00002000 00000000,00000000,000000=
00,00004000 00000000,00000000,00000000,00008000 00000000,00000000,00000=
000,00000001 00000000,00000000,00000000,00000002 00000000,00000000,0000=
0000,00000004 00000000,00000000,00000000,00000008 00000000,00000000,000=
00000,00000010 00000000,00000000,00000000,00000020 00000000,00000000,00=
000000,00000040 00000000,00000000,00000000,00000080 00000000,00000000,0=
0000000,00000100 00000000,00000000,00000000,00000200 00000000,00000000,=
00000000,00000400 00000000,00000000,00000000,00000800 00000000,00000000=
,00000000,00001000
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU14: offline
 domain 0: span 00000000,00000000,00000000,00004000
  groups: 00000000,00000000,00000000,00004000
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00004000 00000000,00000000,000000=
00,00008000 00000000,00000000,00000000,00000001 00000000,00000000,00000=
000,00000002 00000000,00000000,00000000,00000004 00000000,00000000,0000=
0000,00000008 00000000,00000000,00000000,00000010 00000000,00000000,000=
00000,00000020 00000000,00000000,00000000,00000040 00000000,00000000,00=
000000,00000080 00000000,00000000,00000000,00000100 00000000,00000000,0=
0000000,00000200 00000000,00000000,00000000,00000400 00000000,00000000,=
00000000,00000800 00000000,00000000,00000000,00001000 00000000,00000000=
,00000000,00002000
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
CPU15: offline
 domain 0: span 00000000,00000000,00000000,00008000
  groups: 00000000,00000000,00000000,00008000
  domain 1: span ffffffff,ffffffff,ffffffff,ffffffff
   groups: 00000000,00000000,00000000,00008000 00000000,00000000,000000=
00,00000001 00000000,00000000,00000000,00000002 00000000,00000000,00000=
000,00000004 00000000,00000000,00000000,00000008 00000000,00000000,0000=
0000,00000010 00000000,00000000,00000000,00000020 00000000,00000000,000=
00000,00000040 00000000,00000000,00000000,00000080 00000000,00000000,00=
000000,00000100 00000000,00000000,00000000,00000200 00000000,00000000,0=
0000000,00000400 00000000,00000000,00000000,00000800 00000000,00000000,=
00000000,00001000 00000000,00000000,00000000,00002000 00000000,00000000=
,00000000,00004000
ERROR groups don't span domain->span
   domain 2: span 00000000,00000000,00000000,0000ffff
    groups: 00000000,00000000,00000000,0000ffff
checking if image is initramfs... it is
=46reeing initrd memory: 1360k freed
NET: Registered protocol family 16
PCI: Probing PCI hardware
RTAS: event: 6, Type: Internal Device Failure, Severity: 5
RTAS: event: 7, Type: Internal Device Failure, Severity: 5
RTAS: event: 8, Type: Internal Device Failure, Severity: 5
RTAS: event: 9, Type: Internal Device Failure, Severity: 5
RTAS: event: 10, Type: Internal Device Failure, Severity: 5
RTAS: event: 11, Type: Internal Device Failure, Severity: 5
RTAS: event: 12, Type: Internal Device Failure, Severity: 5
RTAS: event: 13, Type: Internal Device Failure, Severity: 5
RTAS: event: 14, Type: Internal Device Failure, Severity: 5
RTAS: event: 15, Type: Internal Device Failure, Severity: 5
RTAS: event: 16, Type: Internal Device Failure, Severity: 5
RTAS: event: 17, Type: Internal Device Failure, Severity: 5
RTAS: event: 18, Type: Internal Device Failure, Severity: 5
RTAS: event: 19, Type: Internal Device Failure, Severity: 5
RTAS: event: 20, Type: Internal Device Failure, Severity: 5
RTAS: event: 21, Type: Internal Device Failure, Severity: 5
RTAS: event: 22, Type: Internal Device Failure, Severity: 5
RTAS: event: 23, Type: Internal Device Failure, Severity: 5
RTAS: event: 24, Type: Internal Device Failure, Severity: 5
RTAS: event: 25, Type: Internal Device Failure, Severity: 5
RTAS: event: 26, Type: Internal Device Failure, Severity: 5
RTAS: event: 27, Type: Internal Device Failure, Severity: 5
RTAS: event: 28, Type: Internal Device Failure, Severity: 5
RTAS: event: 29, Type: Internal Device Failure, Severity: 5
RTAS: event: 30, Type: Internal Device Failure, Severity: 5
RTAS: event: 31, Type: Internal Device Failure, Severity: 5
RTAS: event: 32, Type: Internal Device Failure, Severity: 5
RTAS: event: 33, Type: Internal Device Failure, Severity: 5
RTAS: event: 34, Type: Internal Device Failure, Severity: 5
RTAS: event: 35, Type: Internal Device Failure, Severity: 5
RTAS: event: 36, Type: Internal Device Failure, Severity: 5
RTAS: event: 37, Type: Internal Device Failure, Severity: 5
RTAS: event: 38, Type: Internal Device Failure, Severity: 5
RTAS: event: 39, Type: Internal Device Failure, Severity: 5
RTAS: event: 40, Type: Internal Device Failure, Severity: 5
RTAS: event: 41, Type: Internal Device Failure, Severity: 5
RTAS: event: 42, Type: Internal Device Failure, Severity: 5
RTAS: event: 43, Type: Internal Device Failure, Severity: 5
RTAS: event: 44, Type: Internal Device Failure, Severity: 5
RTAS: event: 45, Type: Internal Device Failure, Severity: 5
RTAS: event: 46, Type: Internal Device Failure, Severity: 5
RTAS: event: 47, Type: Internal Device Failure, Severity: 5
RTAS: event: 48, Type: Internal Device Failure, Severity: 5
RTAS: event: 49, Type: Internal Device Failure, Severity: 5
RTAS: event: 50, Type: Internal Device Failure, Severity: 5
RTAS: event: 51, Type: Internal Device Failure, Severity: 5
RTAS: event: 52, Type: Internal Device Failure, Severity: 5
RTAS: event: 53, Type: Internal Device Failure, Severity: 5
RTAS: event: 54, Type: Internal Device Failure, Severity: 5
RTAS: event: 55, Type: Internal Device Failure, Severity: 5
RTAS: event: 56, Type: Internal Device Failure, Severity: 5
RTAS: event: 57, Type: Internal Device Failure, Severity: 5
RTAS: event: 58, Type: Internal Device Failure, Severity: 5
RTAS: event: 59, Type: Internal Device Failure, Severity: 5
RTAS: event: 60, Type: Internal Device Failure, Severity: 5
RTAS: event: 61, Type: Internal Device Failure, Severity: 5
RTAS: event: 62, Type: Internal Device Failure, Severity: 5
RTAS: event: 63, Type: Internal Device Failure, Severity: 5
RTAS: event: 64, Type: Internal Device Failure, Severity: 5
RTAS: event: 65, Type: Internal Device Failure, Severity: 5
RTAS: event: 66, Type: Internal Device Failure, Severity: 5
RTAS: event: 67, Type: Internal Device Failure, Severity: 5
RTAS: event: 68, Type: Internal Device Failure, Severity: 5
RTAS: event: 69, Type: Internal Device Failure, Severity: 5
RTAS: event: 70, Type: Internal Device Failure, Severity: 5
RTAS: event: 71, Type: Internal Device Failure, Severity: 5
RTAS: event: 72, Type: Internal Device Failure, Severity: 5
RTAS: event: 73, Type: Internal Device Failure, Severity: 5
RTAS: event: 74, Type: Internal Device Failure, Severity: 5
RTAS: event: 75, Type: Internal Device Failure, Severity: 5
RTAS: event: 76, Type: Internal Device Failure, Severity: 5
RTAS: event: 77, Type: Internal Device Failure, Severity: 5
RTAS: event: 78, Type: Internal Device Failure, Severity: 5
RTAS: event: 79, Type: Internal Device Failure, Severity: 5
RTAS: event: 80, Type: Internal Device Failure, Severity: 5
RTAS: event: 81, Type: Internal Device Failure, Severity: 5
RTAS: event: 82, Type: Internal Device Failure, Severity: 5
RTAS: event: 83, Type: Internal Device Failure, Severity: 5
RTAS: event: 84, Type: Internal Device Failure, Severity: 5
RTAS: event: 85, Type: Internal Device Failure, Severity: 5
RTAS: event: 86, Type: Internal Device Failure, Severity: 5
RTAS: event: 87, Type: Internal Device Failure, Severity: 5
RTAS: event: 88, Type: Internal Device Failure, Severity: 5
RTAS: event: 89, Type: Internal Device Failure, Severity: 5
RTAS: event: 90, Type: Internal Device Failure, Severity: 5
RTAS: event: 91, Type: Internal Device Failure, Severity: 5
RTAS: event: 92, Type: Internal Device Failure, Severity: 5
RTAS: event: 93, Type: Internal Device Failure, Severity: 5
RTAS: event: 94, Type: Internal Device Failure, Severity: 5
RTAS: event: 95, Type: Internal Device Failure, Severity: 5
RTAS: event: 96, Type: Internal Device Failure, Severity: 5
RTAS: event: 97, Type: Internal Device Failure, Severity: 5
RTAS: event: 98, Type: Internal Device Failure, Severity: 5
RTAS: event: 99, Type: Internal Device Failure, Severity: 5
RTAS: event: 100, Type: Internal Device Failure, Severity: 5
RTAS: event: 101, Type: Internal Device Failure, Severity: 5
RTAS: event: 102, Type: Internal Device Failure, Severity: 5
RTAS: event: 103, Type: Internal Device Failure, Severity: 5
RTAS: event: 104, Type: Internal Device Failure, Severity: 5
RTAS: event: 105, Type: Internal Device Failure, Severity: 5
RTAS: event: 106, Type: Internal Device Failure, Severity: 5
RTAS: event: 107, Type: Internal Device Failure, Severity: 5
RTAS: event: 108, Type: Internal Device Failure, Severity: 5
RTAS: event: 109, Type: Internal Device Failure, Severity: 5
IOMMU table initialized, virtual merging disabled
ISA bridge at 0000:00:10.0
PCI: Probing PCI hardware done
get_random_bytes called before random driver initialization
TC classifier action (bugs to netdev@oss.sgi.com cc hadi@cyberus.ca)
probe_bus_pseries: processing c000000000868280
probe_bus_pseries: processing c000000000868448
probe_bus_pseries: processing c000000000868650
RTAS daemon started
audit: initializing netlink socket (disabled)
audit(1093353104.576:0): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Initializing Cryptographic API
HVSI: registered 0 devices
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabl=
ed
ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 123456K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
mice: PS/2 mouse device common for all mice
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
oprofile: using ppc64/power4 performance monitoring.
NET: Registered protocol family 2
IP: routing cache hash table of 65536 buckets, 1024Kbytes
TCP: Hash tables configured (established 1048576 bind 65536)
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
=46reeing unused kernel memory: 192k freed
SCSI subsystem initialized
PCI: Enabling device: (0002:41:01.0), cmd 143
sym0: <1010-66> rev 0x1 at pci 0002:41:01.0 irq 69
sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
Using cfq io scheduler
sym0:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:8:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:8:0): Beginning Domain Validation
sym0:8: asynchronous.
sym0:8: wide asynchronous.
sym0:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:8:0): Ending Domain Validation
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
Attached scsi disk sda at scsi0, channel 0, id 8, lun 0
sym0:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:10:0: tagged command queuing enabled, command queue depth 16.
scsi(0:0:10:0): Beginning Domain Validation
sym0:10: asynchronous.
sym0:10: wide asynchronous.
sym0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(0:0:10:0): Ending Domain Validation
SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1 sdb2 sdb3
Attached scsi disk sdb at scsi0, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4HD PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(0:0:15:0): Beginning Domain Validation
scsi(0:0:15:0): Ending Domain Validation
PCI: Enabling device: (0003:61:01.0), cmd 143
sym1: <875> rev 0x3 at pci 0003:61:01.0 irq 86
sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.1.18j
sym1:5:0: ABORT operation started.
sym1:5:0: ABORT operation timed-out.
sym1:5:0: DEVICE RESET operation started.
sym1:5:0: DEVICE RESET operation complete.
sym1:5:control msgout: c.
sym1: TARGET 5 has been reset.
sym1:5:0: ABORT operation started.
sym1:5:0: ABORT operation complete.
sym1:5:0: BUS RESET operation started.
sym1:5:0: BUS RESET operation complete.
sym1: SCSI BUS reset detected.
sym1: SCSI BUS has been reset.
  Vendor: IBM       Model: DROM00203         Rev: 7R41
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi(1:0:5:0): Beginning Domain Validation
sym1:5: wide asynchronous.
sym1:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 14)
scsi(1:0:5:0): Domain Validation skipping write tests
scsi(1:0:5:0): Ending Domain Validation
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
Attached scsi CD-ROM sr0 at scsi1, channel 0, id 5, lun 0
sym1:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
  Vendor: HP        Model: IBM-C568303030!D  Rev: C209
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi(1:0:6:0): Beginning Domain Validation
sym1:6: FAST-20 SCSI 20.0 MB/s ST (50.0 ns, offset 16)
sym1:6: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 16)
scsi(1:0:6:0): Domain Validation skipping write tests
scsi(1:0:6:0): Ending Domain Validation
PCI: Enabling device: (0008:41:01.0), cmd 143
sym2: <1010-66> rev 0x1 at pci 0008:41:01.0 irq 91
sym2: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym2: SCSI BUS has been reset.
scsi2 : sym-2.1.18j
sym2:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym2:8:0: tagged command queuing enabled, command queue depth 16.
scsi(2:0:8:0): Beginning Domain Validation
sym2:8: asynchronous.
sym2:8: wide asynchronous.
sym2:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(2:0:8:0): Ending Domain Validation
SCSI device sdc: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdc: drive cache: write through
 sdc:
Attached scsi disk sdc at scsi2, channel 0, id 8, lun 0
sym2:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym2:10:0: tagged command queuing enabled, command queue depth 16.
scsi(2:0:10:0): Beginning Domain Validation
sym2:10: asynchronous.
sym2:10: wide asynchronous.
sym2:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(2:0:10:0): Ending Domain Validation
SCSI device sdd: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdd: drive cache: write through
 sdd:
Attached scsi disk sdd at scsi2, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4HD PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(2:0:15:0): Beginning Domain Validation
scsi(2:0:15:0): Ending Domain Validation
PCI: Enabling device: (0009:41:01.0), cmd 143
sym3: <1010-66> rev 0x1 at pci 0009:41:01.0 irq 107
sym3: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym3: SCSI BUS has been reset.
scsi3 : sym-2.1.18j
sym3:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym3:8:0: tagged command queuing enabled, command queue depth 16.
scsi(3:0:8:0): Beginning Domain Validation
sym3:8: asynchronous.
sym3:8: wide asynchronous.
sym3:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(3:0:8:0): Ending Domain Validation
SCSI device sde: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sde: drive cache: write through
 sde: sde1
Attached scsi disk sde at scsi3, channel 0, id 8, lun 0
sym3:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym3:10:0: tagged command queuing enabled, command queue depth 16.
scsi(3:0:10:0): Beginning Domain Validation
sym3:10: asynchronous.
sym3:10: wide asynchronous.
sym3:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(3:0:10:0): Ending Domain Validation
SCSI device sdf: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdf: drive cache: write through
 sdf: sdf1
Attached scsi disk sdf at scsi3, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4HC PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(3:0:15:0): Beginning Domain Validation
scsi(3:0:15:0): Ending Domain Validation
PCI: Enabling device: (000b:41:01.0), cmd 143
sym4: <1010-66> rev 0x1 at pci 000b:41:01.0 irq 347
sym4: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym4: SCSI BUS has been reset.
scsi4 : sym-2.1.18j
sym4:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym4:8:0: tagged command queuing enabled, command queue depth 16.
scsi(4:0:8:0): Beginning Domain Validation
sym4:8: asynchronous.
sym4:8: wide asynchronous.
sym4:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(4:0:8:0): Ending Domain Validation
SCSI device sdg: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdg: drive cache: write through
 sdg: sdg1
Attached scsi disk sdg at scsi4, channel 0, id 8, lun 0
sym4:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym4:10:0: tagged command queuing enabled, command queue depth 16.
scsi(4:0:10:0): Beginning Domain Validation
sym4:10: asynchronous.
sym4:10: wide asynchronous.
sym4:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(4:0:10:0): Ending Domain Validation
SCSI device sdh: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdh: drive cache: write through
 sdh: sdh1
Attached scsi disk sdh at scsi4, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4HB PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(4:0:15:0): Beginning Domain Validation
scsi(4:0:15:0): Ending Domain Validation
PCI: Enabling device: (000c:41:01.0), cmd 143
sym5: <1010-66> rev 0x1 at pci 000c:41:01.0 irq 363
sym5: No NVRAM, ID 7, Fast-80, LVD, parity checking
sym5: SCSI BUS has been reset.
scsi5 : sym-2.1.18j
sym5:8: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym5:8:0: tagged command queuing enabled, command queue depth 16.
scsi(5:0:8:0): Beginning Domain Validation
sym5:8: asynchronous.
sym5:8: wide asynchronous.
sym5:8: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(5:0:8:0): Ending Domain Validation
SCSI device sdi: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdi: drive cache: write through
 sdi: sdi1
Attached scsi disk sdi at scsi5, channel 0, id 8, lun 0
sym5:10: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 31)
  Vendor: IBM       Model: ST336753LC        Rev: C517
  Type:   Direct-Access                      ANSI SCSI revision: 03
sym5:10:0: tagged command queuing enabled, command queue depth 16.
scsi(5:0:10:0): Beginning Domain Validation
sym5:10: asynchronous.
sym5:10: wide asynchronous.
sym5:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
scsi(5:0:10:0): Ending Domain Validation
SCSI device sdj: 71096640 512-byte hdwr sectors (36401 MB)
SCSI device sdj: drive cache: write through
 sdj: sdj1
Attached scsi disk sdj at scsi5, channel 0, id 10, lun 0
  Vendor: IBM       Model: HSBPD4HA PU3SCSI  Rev: 0016
  Type:   Enclosure                          ANSI SCSI revision: 02
scsi(5:0:15:0): Beginning Domain Validation
scsi(5:0:15:0): Ending Domain Validation
ReiserFS: sdb3: found reiserfs format "3.6" with standard journal
ReiserFS: sdb3: using ordered data mode
ReiserFS: sdb3: journal params: device sdb3, size 8192, journal first b=
lock 18, max trans len 1024, max batch 900, max commit age 30, max tran=
s age 30
ReiserFS: sdb3: checking transaction log (sdb3)
ReiserFS: sdb3: Using r5 hash to sort names
ioctl32(showconsole:1369): Unknown cmd fd(0) cmd(40045432){00} arg(ffff=
ea88) on /dev/console
ioctl32(showconsole:1486): Unknown cmd fd(0) cmd(40045432){00} arg(ffff=
e9f8) on /dev/console
md: md0 stopped.
md: bind<sdg1>
md: bind<sdh1>
md: bind<sdi1>
md: bind<sdj1>
md: bind<sdf1>
md: raid0 personality registered as nr 2
md0: setting max_sectors to 128, segment boundary to 32767
raid0: looking at sdf1
raid0:   comparing sdf1(35548032) with sdf1(35548032)
raid0:   END
raid0:   =3D=3D> UNIQUE
raid0: 1 zones
raid0: looking at sdj1
raid0:   comparing sdj1(35548032) with sdf1(35548032)
raid0:   EQUAL
raid0: looking at sdi1
raid0:   comparing sdi1(35548032) with sdf1(35548032)
raid0:   EQUAL
raid0: looking at sdh1
raid0:   comparing sdh1(35548032) with sdf1(35548032)
raid0:   EQUAL
raid0: looking at sdg1
raid0:   comparing sdg1(35548032) with sdf1(35548032)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 177740160 blocks.
raid0 : conf->hash_spacing is 177740160 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
ioctl32(showconsole:1574): Unknown cmd fd(0) cmd(40045432){00} arg(ffff=
ea18) on /dev/console
ReiserFS: sde1: found reiserfs format "3.6" with standard journal
ReiserFS: sde1: using ordered data mode
ReiserFS: sde1: journal params: device sde1, size 8192, journal first b=
lock 18, max trans len 1024, max batch 900, max commit age 30, max tran=
s age 30
ReiserFS: sde1: checking transaction log (sde1)
ReiserFS: sde1: Using r5 hash to sort names
ioctl32(showconsole:1649): Unknown cmd fd(0) cmd(40045432){00} arg(ffff=
ea28) on /dev/console
ioctl32(showconsole:1855): Unknown cmd fd(0) cmd(40045432){00} arg(ffff=
ea68) on /dev/console
e100: Intel(R) PRO/100 Network Driver, 3.0.27-k2-NAPI
e100: Copyright(c) 1999-2004 Intel Corporation
PCI: Enabling device: (0001:01:01.0), cmd 143
e100: eth0: e100_probe: addr 0x3fe00030000, irq 51, MAC addr 00:02:55:6=
=46:6A:BD
PCI: Enabling device: (0001:21:01.0), cmd 143
e100: eth1: e100_probe: addr 0x3fe08030000, irq 52, MAC addr 00:02:55:6=
=46:6A:CF
usbcore: registered new driver usbfs
usbcore: registered new driver hub
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
e100: eth1: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
Disabled Privacy Extensions on device c0000000004e13c0(lo)
IPv6 over IPv4 tunneling driver
Disabled Privacy Extensions on device c00000020bb97000(sit0)
sym1: SCSI parity error detected: SCR1=3D132 DBC=3D50000000 SBCL=3D0
nfs warning: mount version older than kernel
nfs warning: mount version older than kernel
nfs warning: mount version older than kernel
nfs warning: mount version older than kernel

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
