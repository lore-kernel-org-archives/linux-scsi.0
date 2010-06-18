From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: HighPoint Technologies, Inc. Device [1103:2680]
Date: Fri, 18 Jun 2010 14:06:04 +0200
Message-ID: <4C1B612C.8070503@powercraft.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000904090809000701080905"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:60164 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758554Ab0FRMGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2010 08:06:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux@highpoint-tech.com

This is a multi-part message in MIME format.
--------------000904090809000701080905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello everybody,

I bought a HighPoint Technologies RocketRAID 2680 controller for
testing with a GNU/Linux kernel on GNU/Debian and Ubuntu.

It seems there is no kernel module for the 2600 series or the 2700
series. The HighPoint website [1][2] keeps claiming there are open
soure drivers available. I know open source is not the same as free
software, but it is very very misleading, because it does not work.

Will the below devices ever be supported in the upstream kernel code?
RocketRAID 2700 Family Series (Marvell 9485 SAS/SATA 6Gb/s)
RocketRAID 2600 Family Series (Marvell 6485/6445 SAS/SATA 3Gb/s)

See the attached document for more device information.

[1] http://www.highpoint-tech.com/USA_new/series_rr2600.htm
[2] http://www.highpoint-tech.com/USA_new/series_rr2700.htm

Thanks in advance,

With kind regards,

Jelle de Jong

--------------000904090809000701080905
Content-Type: text/plain;
 name="HighPoint Technologies RocketRAID 2680.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="HighPoint Technologies RocketRAID 2680.txt"

#-----------------------------------------------------------------------

http://www.highpoint-tech.com/USA/rr2680.htm
http://www.support-highpoint-tech.com/Main/rr26xx/268x/Linux/opensrc/rr268x-linux-src-v1.4-091124-1558.tar.gz

#-----------------------------------------------------------------------

RocketRAID 2700 Family Series (Marvell 9485 SAS/SATA 6Gb/s)
RocketRAID 2600 Family Series (Marvell 6485/6445 SAS/SATA 3Gb/s)

#-----------------------------------------------------------------------

# cat /proc/cmdline
BOOT_IMAGE=/casper/vmlinuz file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz quiet splash -- maybe-ubiquity

# cat /proc/version
Linux version 2.6.32-21-generic (buildd@rothera) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2010

#-----------------------------------------------------------------------

root@ubuntu:~# lspci -nn
00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] RS780 Host Bridge Alternate [1022:9601]
00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx) [1022:9602]
00:02.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0) [1022:9603]
00:11.0 SATA controller [0106]: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] [1002:4391] (rev 40)
00:12.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
00:12.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
00:13.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
00:13.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 41)
00:14.3 ISA bridge [0601]: ATI Technologies Inc SB700/SB800 LPC host controller [1002:439d] (rev 40)
00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384] (rev 40)
00:14.5 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller [1002:4399]
00:15.0 PCI bridge [0604]: ATI Technologies Inc Device [1002:43a0]
00:15.1 PCI bridge [0604]: ATI Technologies Inc Device [1002:43a1]
00:16.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller [1002:4397]
00:16.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI Controller [1002:4396]
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration [1022:1200]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map [1022:1201]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller [1022:1202]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control [1022:1203]
00:18.4 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control [1022:1204]
01:05.0 VGA compatible controller [0300]: ATI Technologies Inc Device [1002:9714]
02:00.0 SCSI storage controller [0100]: HighPoint Technologies, Inc. Device [1103:2680] (rev 01)
03:05.0 SCSI storage controller [0100]: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller [11ab:6081] (rev 09)
04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
05:00.0 Ethernet controller [0200]: Intel Corporation 82574L Gigabit Network Connection [8086:10d3]

# lspci -vv -nn -d 1103:2680
02:00.0 SCSI storage controller [0100]: HighPoint Technologies, Inc. Device [1103:2680] (rev 01)
    Subsystem: HighPoint Technologies, Inc. Device [1103:0000]
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 2: I/O ports at bc00 [size=128]
    Region 4: Memory at fdbf0000 (64-bit, non-prefetchable) [size=64K]
    Expansion ROM at fdb80000 [disabled] [size=256K]
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 2048 bytes
        DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <256ns, L1 unlimited
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100] Advanced Error Reporting <?>

#-----------------------------------------------------------------------

# modinfo hptiop
filename:       /lib/modules/2.6.32-21-generic/kernel/drivers/scsi/hptiop.ko
license:        GPL
description:    HighPoint RocketRAID 3xxx/4xxx Controller Driver
author:         HighPoint Technologies, Inc.
srcversion:     2393E04C627C2B8A9B54C7E
alias:          pci:v00001103d00003020sv*sd*bc*sc*i*
alias:          pci:v00001103d00003122sv*sd*bc*sc*i*
alias:          pci:v00001103d00003120sv*sd*bc*sc*i*
alias:          pci:v00001103d00004400sv*sd*bc*sc*i*
alias:          pci:v00001103d00004322sv*sd*bc*sc*i*
alias:          pci:v00001103d00004321sv*sd*bc*sc*i*
alias:          pci:v00001103d00004320sv*sd*bc*sc*i*
alias:          pci:v00001103d00004311sv*sd*bc*sc*i*
alias:          pci:v00001103d00004310sv*sd*bc*sc*i*
alias:          pci:v00001103d00004211sv*sd*bc*sc*i*
alias:          pci:v00001103d00004210sv*sd*bc*sc*i*
alias:          pci:v00001103d00003560sv*sd*bc*sc*i*
alias:          pci:v00001103d00003540sv*sd*bc*sc*i*
alias:          pci:v00001103d00003530sv*sd*bc*sc*i*
alias:          pci:v00001103d00003522sv*sd*bc*sc*i*
alias:          pci:v00001103d00003521sv*sd*bc*sc*i*
alias:          pci:v00001103d00003520sv*sd*bc*sc*i*
alias:          pci:v00001103d00003511sv*sd*bc*sc*i*
alias:          pci:v00001103d00003510sv*sd*bc*sc*i*
alias:          pci:v00001103d00003410sv*sd*bc*sc*i*
alias:          pci:v00001103d00003320sv*sd*bc*sc*i*
alias:          pci:v00001103d00003220sv*sd*bc*sc*i*
depends:
vermagic:       2.6.32-21-generic SMP mod_unload modversions 586

#-----------------------------------------------------------------------

--------------000904090809000701080905--
