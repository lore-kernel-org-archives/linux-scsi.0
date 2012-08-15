From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: areca [17d3:1320] controller not working with linux 3.5 and mvsas?!
Date: Wed, 15 Aug 2012 19:45:08 +0200
Message-ID: <502BE024.8000309@powercraft.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040409090304040405020704"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.cambriumhosting.nl ([217.19.16.174]:36959 "EHLO
	relay02.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660Ab2HORy6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 13:54:58 -0400
Received: from relay02.cambriumhosting.nl (localhost [127.0.0.1])
	by relay02.cambriumhosting.nl (Postfix) with ESMTP id ADD6D6000313
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 19:45:10 +0200 (CEST)
Received: from yessica.powercraft.nl (ebony.powercraft.nl [82.197.193.110])
	by relay02.cambriumhosting.nl (Postfix) with ESMTP id 998C46000189
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 19:45:10 +0200 (CEST)
Received: from [IPv6:2a02:58:5:2e00:62eb:69ff:fe27:4976] (unknown [IPv6:2a02:58:5:2e00:62eb:69ff:fe27:4976])
	by yessica.powercraft.nl (Postfix) with ESMTPSA id 584A824DBF
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 19:45:10 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040409090304040405020704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello everybody,

I am trying to get my Areca sata non-raid controller[1] working, but
so far no luck.

Could somebody tell me if the device is supported and expected to work?

I attached my kernel and device information.

I could really use a fast response, so I know if I should order three
other controllers (the older 3Gb/s version worked).

[1] http://www.areca.com.tw/products/sasnoneraid6g.htm

Kind regards,

Jelle de Jong
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iJwEAQECAAYFAlAr4B8ACgkQ1WclBW9j5HlQxgP+NhdLhBuU0QMjH6UXYK5syEGH
8dEmSV92HIViq9nBj9f4cu4IpZycjm5bc58T+l21F7ihXsDClpL+oGz89VarqtJm
hehQGy3ZARxaH3qxuGa6CkDaTYBxutlTvScBXAVQd6CMchEx5JZK7OyrRnAi9qQD
tEGLc3mYeuUVYF/FW5A=
=Kp32
-----END PGP SIGNATURE-----

--------------040409090304040405020704
Content-Type: text/plain;
 name="areca-17d3-1320-linux-image-3.5-trunk-amd64-notworking-v0.1.1.j.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="areca-17d3-1320-linux-image-3.5-trunk-amd64-notworking-v0.1.";
 filename*1="1.j.txt"

root@debian:~# lspci -nn | grep SCSI
03:00.0 SCSI storage controller [0100]: Areca Technology Corp. Device [17d3:1320] (rev 03)

root@debian:~# uname -a
Linux debian 3.5-trunk-amd64 #1 SMP Thu Aug 2 18:38:39 UTC 2012 x86_64 GNU/Linux

root@debian:~# cat /etc/debian_version
wheezy/sid

root@debian:~# lspci -d 17d3:1320 -vv
03:00.0 SCSI storage controller: Areca Technology Corp. Device 1320 (rev 03)
    Subsystem: Areca Technology Corp. Device 1320
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 26
    Region 0: Memory at b2540000 (64-bit, non-prefetchable) [size=128K]
    Region 2: Memory at b2500000 (64-bit, non-prefetchable) [size=256K]
    Expansion ROM at b1900000 [disabled] [size=64K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [70] Express (v2) Endpoint, MSI 00
        DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 256 bytes, MaxReadReq 512 bytes
        DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap: Port #0, Speed 5GT/s, Width x8, ASPM L0s L1, Latency L0 <512ns, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        DevCap2: Completion Timeout: Not Supported, TimeoutDis+
        DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
        LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
             Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
             Compliance De-emphasis: -6dB
        LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
             EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
    Capabilities: [140 v1] Virtual Channel
        Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:   ArbSelect=Fixed
        Status: InProgress-
        VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status: NegoPending- InProgress-
    Kernel driver in use: mvsas

# modinfo mvsas
filename:       /lib/modules/3.5-trunk-amd64/kernel/drivers/scsi/mvsas/mvsas.ko
license:        GPL
version:        0.8.16
description:    Marvell 88SE6440 SAS/SATA controller driver
author:         Jeff Garzik <jgarzik@pobox.com>
srcversion:     C07009AAB685097ABCF2E39
alias:          pci:v00001B85d00001084sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001083sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001080sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001044sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001043sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001042sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001041sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001040sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001022sv*sd*bc*sc*i*
alias:          pci:v00001B85d00001021sv*sd*bc*sc*i*
alias:          pci:v00001B4Bd00009485sv*sd00009480bc*sc*i*
alias:          pci:v00001B4Bd00009445sv*sd00009480bc*sc*i*
alias:          pci:v00001B4Bd00009480sv*sd00009480bc*sc*i*
alias:          pci:v00001103d00002760sv*sd*bc*sc*i*
alias:          pci:v00001103d00002744sv*sd*bc*sc*i*
alias:          pci:v00001103d00002740sv*sd*bc*sc*i*
alias:          pci:v00001103d00002722sv*sd*bc*sc*i*
alias:          pci:v00001103d00002721sv*sd*bc*sc*i*
alias:          pci:v00001103d00002720sv*sd*bc*sc*i*
alias:          pci:v00001103d00002710sv*sd*bc*sc*i*
alias:          pci:v00009005d00000450sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001320sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001300sv*sd*bc*sc*i*
alias:          pci:v000011ABd00009180sv*sd*bc*sc*i*
alias:          pci:v000011ABd00009480sv*sd*bc*sc*i*
alias:          pci:v000011ABd00006485sv*sd*bc*sc*i*
alias:          pci:v000011ABd00006440sv*sd*bc*sc*i*
alias:          pci:v000011ABd00006440sv*sd00006480bc*sc*i*
alias:          pci:v000011ABd00006340sv*sd*bc*sc*i*
alias:          pci:v000011ABd00006320sv*sd*bc*sc*i*
depends:        libsas,scsi_transport_sas,scsi_mod
intree:         Y
vermagic:       3.5-trunk-amd64 SMP mod_unload modversions
parm:           collector:
    If greater than one, tells the SAS Layer to run in Task Collector
    Mode.  If 1 or 0, tells the SAS Layer to run in Direct Mode.
    The mvsas SAS LLDD supports both modes.
    Default: 1 (Direct Mode).
 (int)


root@debian:~# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5-trunk-amd64 (Debian 3.5-1~experimental.1) (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-8) ) #1 SMP Thu Aug 2 18:38:39 UTC 2012
[    0.000000] Command line: initrd=/live/initrd.img boot=live config persistent noprompt BOOT_IMAGE=/live/vmlinuz
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000094000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008c335fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008c336000-0x000000008c414fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008c415000-0x000000008c661fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008c662000-0x000000008da61fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008da62000-0x000000008f601fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f602000-0x000000008f64efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f64f000-0x000000008f6e5fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6e6000-0x000000008f6effff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f6f0000-0x000000008f6f0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6f1000-0x000000008f7cefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f7cf000-0x000000008f7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a0000000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed44fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: Intel Corporation S5520HC/S5520HC, BIOS S5500.86B.01.00.0061.030920121535 03/09/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x270000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-through
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFF0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FFC0000000 write-back
[    0.000000]   4 base 0240000000 mask FFE0000000 write-back
[    0.000000]   5 base 0260000000 mask FFF0000000 write-back
[    0.000000]   6 base 00B0000000 mask FFFF000000 write-combining
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8c336 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at [ffff8800000fda90]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008e000] 8e000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x8c335fff]
[    0.000000]  [mem 0x00000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x8c1fffff] page 2M
[    0.000000]  [mem 0x8c200000-0x8c335fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x8c335fff @ [mem 0x1fbfd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x26fffffff]
[    0.000000]  [mem 0x100000000-0x23fffffff] page 1G
[    0.000000]  [mem 0x240000000-0x26fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x26fffffff @ [mem 0x8c334000-0x8c335fff]
[    0.000000] RAMDISK: [mem 0x7f4a9000-0x7fffefff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000008f7fd120 0008C (v01 INTEL  S5520HC  00000000      01000013)
[    0.000000] ACPI: FACP 000000008f7fb000 000F4 (v04 INTEL  S5520HC  00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000008f7f4000 06531 (v02 INTEL  S5520HC  00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000008f6f1000 00040
[    0.000000] ACPI: APIC 000000008f7f3000 001A8 (v02 INTEL  S5520HC  00000000 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000008f7f2000 0003C (v01 INTEL  S5520HC  00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000008f7f1000 00038 (v01 INTEL  S5520HC  00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000008f7f0000 00030 (v01 INTEL  S5520HC  00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 000000008f7ef000 00050 (v01 INTEL  S5520HC  00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000008f7ee000 00040 (v01 INTEL  S5520HC  00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000008f7d3000 1AFC4 (v02  INTEL SSDT  PM 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008f7d2000 001D8 (v02  INTEL IPMI     00004000 INTL 20061109)
[    0.000000] ACPI: HEST 000000008f7d1000 000A8 (v01 INTEL  S5520HC  00000001 INTL 00000001)
[    0.000000] ACPI: BERT 000000008f7d0000 00030 (v01 INTEL  S5520HC  00000001 INTL 00000001)
[    0.000000] ACPI: ERST 000000008f7cf000 00230 (v01 INTEL  S5520HC  00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 000000008f6f0000 00130 (v01 INTEL  S5520HC  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] NUMA: Initialized distance table, cnt=1
[    0.000000] NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000026fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x26fffffff]
[    0.000000]   NODE_DATA [mem 0x26fffc000-0x26fffffff]
[    0.000000]  [ffffea0000000000-ffffea00089fffff] PMD -> [ffff880267600000-ffff88026e7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x26fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00093fff]
[    0.000000]   node   0: [mem 0x00100000-0x8c335fff]
[    0.000000]   node   0: [mem 0x100000000-0x26fffffff]
[    0.000000] On node 0 totalpages: 2081466
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 555886 pages, LIFO batch:31
[    0.000000]   Normal zone: 20608 pages used for memmap
[    0.000000]   Normal zone: 1486720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec90000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec90000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 12 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000008c336000 - 000000008c415000
[    0.000000] PM: Registered nosave memory: 000000008c415000 - 000000008c662000
[    0.000000] PM: Registered nosave memory: 000000008c662000 - 000000008da62000
[    0.000000] PM: Registered nosave memory: 000000008da62000 - 000000008f602000
[    0.000000] PM: Registered nosave memory: 000000008f602000 - 000000008f64f000
[    0.000000] PM: Registered nosave memory: 000000008f64f000 - 000000008f6e6000
[    0.000000] PM: Registered nosave memory: 000000008f6e6000 - 000000008f6f0000
[    0.000000] PM: Registered nosave memory: 000000008f6f0000 - 000000008f6f1000
[    0.000000] PM: Registered nosave memory: 000000008f6f1000 - 000000008f7cf000
[    0.000000] PM: Registered nosave memory: 000000008f7cf000 - 000000008f800000
[    0.000000] PM: Registered nosave memory: 000000008f800000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000a0000000
[    0.000000] PM: Registered nosave memory: 00000000a0000000 - 00000000b0000000
[    0.000000] PM: Registered nosave memory: 00000000b0000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fd000000
[    0.000000] PM: Registered nosave memory: 00000000fd000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed45000
[    0.000000] PM: Registered nosave memory: 00000000fed45000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0xb0000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88026f200000 s82496 r8192 d24000 u131072
[    0.000000] pcpu-alloc: s82496 r8192 d24000 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 -- -- -- -- -- -- -- --
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2046516
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=/live/initrd.img boot=live config persistent noprompt BOOT_IMAGE=/live/vmlinuz
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8120252k/10223616k available (3468k kernel code, 1897752k absent, 205612k reserved, 3229k data, 580k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2666.701 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.40 BogoMIPS (lpj=10666804)
[    0.000210] pid_max: default: 32768 minimum: 301
[    0.000341] Security Framework initialized
[    0.000443] AppArmor: AppArmor disabled by boot time parameter
[    0.000959] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.011218] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012295] Mount-cache hash table entries: 256
[    0.012582] Initializing cgroup subsys cpuacct
[    0.012684] Initializing cgroup subsys memory
[    0.012794] Initializing cgroup subsys devices
[    0.012895] Initializing cgroup subsys freezer
[    0.012996] Initializing cgroup subsys net_cls
[    0.013096] Initializing cgroup subsys blkio
[    0.013196] Initializing cgroup subsys perf_event
[    0.013321] CPU: Physical Processor ID: 0
[    0.013420] CPU: Processor Core ID: 0
[    0.013525] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.013525] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.013679] mce: CPU supports 9 MCE banks
[    0.013786] CPU0: Thermal monitoring enabled (TM1)
[    0.013892] using mwait in idle threads.
[    0.014306] ACPI: Core revision 20120320
[    0.025123] Switched APIC routing to physical flat.
[    0.025741] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.065426] CPU0: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz stepping 02
[    0.169874] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.170252] CPUID marked event: 'bus cycles' unavailable
[    0.170355] ... version:                3
[    0.170454] ... bit width:              48
[    0.170552] ... generic registers:      4
[    0.170651] ... value mask:             0000ffffffffffff
[    0.170753] ... max period:             000000007fffffff
[    0.170856] ... fixed-purpose events:   3
[    0.170954] ... event mask:             000000070000000f
[    0.171385] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.171705] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11
[    0.317769] Brought up 12 CPUs
[    0.317953] Total of 12 processors activated (64000.82 BogoMIPS).
[    0.331659] devtmpfs: initialized
[    0.335563] PM: Registering ACPI NVS region [mem 0x8c336000-0x8c414fff] (913408 bytes)
[    0.335729] PM: Registering ACPI NVS region [mem 0x8c662000-0x8da61fff] (20971520 bytes)
[    0.336505] PM: Registering ACPI NVS region [mem 0x8f6e6000-0x8f6effff] (40960 bytes)
[    0.336643] PM: Registering ACPI NVS region [mem 0x8f6f1000-0x8f7cefff] (909312 bytes)
[    0.336898] dummy:
[    0.337059] NET: Registered protocol family 16
[    0.337309] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.337449] ACPI: bus type pci registered
[    0.337614] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
[    0.337756] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
[    0.350132] PCI: Using configuration type 1 for base access
[    0.351089] bio: create slab <bio-0> at 0
[    0.351287] ACPI: Added _OSI(Module Device)
[    0.351387] ACPI: Added _OSI(Processor Device)
[    0.351488] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.351589] ACPI: Added _OSI(Processor Aggregator Device)
[    0.353081] ACPI: EC: Look up EC in DSDT
[    0.353259] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20120320/dsopcode-236)
[    0.353526] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff8802668819c0), AE_AML_BUFFER_LIMIT (20120320/psparse-536)
[    0.383429] ACPI: Interpreter enabled
[    0.383529] ACPI: (supports S0 S1 S5)
[    0.383815] ACPI: Using IOAPIC for interrupt routing
[    0.389816] ACPI: No dock devices found.
[    0.389941] HEST: Table parsing has been initialized.
[    0.390045] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.390531] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fd])
[    0.391161] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.391270] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.391378] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.391514] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000cbfff]
[    0.391649] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfedfffff]
[    0.391785] pci_root PNP0A08:00: host bridge window [mem 0xb0000000-0xfdffffff]
[    0.391923] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    0.392104] PCI host bridge to bus 0000:00
[    0.392204] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.392310] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.392417] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.392526] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    0.392635] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfdffffff]
[    0.392753] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    0.392799] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.392820] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.392867] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.392888] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.392935] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.392956] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    0.393003] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.393025] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.393072] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.393092] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.393140] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.393160] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    0.393215] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    0.393263] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[    0.393322] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[    0.393371] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    0.393381] pci 0000:00:13.0: reg 10: [mem 0xb2723000-0xb2723fff]
[    0.393421] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.393437] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.393493] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.393549] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.393602] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.393647] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
[    0.393697] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.393708] pci 0000:00:16.0: reg 10: [mem 0xb2700000-0xb2703fff 64bit]
[    0.393766] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.393776] pci 0000:00:16.1: reg 10: [mem 0xb2704000-0xb2707fff 64bit]
[    0.393834] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.393845] pci 0000:00:16.2: reg 10: [mem 0xb2708000-0xb270bfff 64bit]
[    0.393903] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.393913] pci 0000:00:16.3: reg 10: [mem 0xb270c000-0xb270ffff 64bit]
[    0.393972] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.393982] pci 0000:00:16.4: reg 10: [mem 0xb2710000-0xb2713fff 64bit]
[    0.394040] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.394050] pci 0000:00:16.5: reg 10: [mem 0xb2714000-0xb2717fff 64bit]
[    0.394109] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.394119] pci 0000:00:16.6: reg 10: [mem 0xb2718000-0xb271bfff 64bit]
[    0.394177] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.394187] pci 0000:00:16.7: reg 10: [mem 0xb271c000-0xb271ffff 64bit]
[    0.394248] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.394286] pci 0000:00:1a.0: reg 20: [io  0x30c0-0x30df]
[    0.394332] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.394369] pci 0000:00:1a.1: reg 20: [io  0x30a0-0x30bf]
[    0.394415] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.394452] pci 0000:00:1a.2: reg 20: [io  0x3080-0x309f]
[    0.394506] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.394525] pci 0000:00:1a.7: reg 10: [mem 0xb2721000-0xb27213ff]
[    0.394605] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.394626] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.394687] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.394711] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.394772] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.394795] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.394833] pci 0000:00:1d.0: reg 20: [io  0x3060-0x307f]
[    0.394878] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.394916] pci 0000:00:1d.1: reg 20: [io  0x3040-0x305f]
[    0.394961] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.394999] pci 0000:00:1d.2: reg 20: [io  0x3020-0x303f]
[    0.395053] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.395073] pci 0000:00:1d.7: reg 10: [mem 0xb2720000-0xb27203ff]
[    0.395153] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.395173] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.395230] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.395303] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.395441] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    0.395579] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[    0.395755] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    0.395768] pci 0000:00:1f.2: reg 10: [io  0x3138-0x313f]
[    0.395775] pci 0000:00:1f.2: reg 14: [io  0x314c-0x314f]
[    0.395782] pci 0000:00:1f.2: reg 18: [io  0x3130-0x3137]
[    0.395789] pci 0000:00:1f.2: reg 1c: [io  0x3148-0x314b]
[    0.395795] pci 0000:00:1f.2: reg 20: [io  0x3110-0x311f]
[    0.395802] pci 0000:00:1f.2: reg 24: [io  0x3100-0x310f]
[    0.395843] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.395856] pci 0000:00:1f.3: reg 10: [mem 0xb2722000-0xb27220ff 64bit]
[    0.395874] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.395904] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[    0.395918] pci 0000:00:1f.5: reg 10: [io  0x3128-0x312f]
[    0.395924] pci 0000:00:1f.5: reg 14: [io  0x3144-0x3147]
[    0.395931] pci 0000:00:1f.5: reg 18: [io  0x3120-0x3127]
[    0.395938] pci 0000:00:1f.5: reg 1c: [io  0x3140-0x3143]
[    0.395945] pci 0000:00:1f.5: reg 20: [io  0x30f0-0x30ff]
[    0.395951] pci 0000:00:1f.5: reg 24: [io  0x30e0-0x30ef]
[    0.396032] pci 0000:01:00.0: [8086:10a7] type 00 class 0x020000
[    0.396043] pci 0000:01:00.0: reg 10: [mem 0xb2620000-0xb263ffff]
[    0.396057] pci 0000:01:00.0: reg 18: [io  0x2020-0x203f]
[    0.396065] pci 0000:01:00.0: reg 1c: [mem 0xb2644000-0xb2647fff]
[    0.396125] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.396156] pci 0000:01:00.1: [8086:10a7] type 00 class 0x020000
[    0.396167] pci 0000:01:00.1: reg 10: [mem 0xb2600000-0xb261ffff]
[    0.396182] pci 0000:01:00.1: reg 18: [io  0x2000-0x201f]
[    0.396190] pci 0000:01:00.1: reg 1c: [mem 0xb2640000-0xb2643fff]
[    0.396250] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    0.398477] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.398582] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.398585] pci 0000:00:01.0:   bridge window [mem 0xb2600000-0xb26fffff]
[    0.398618] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.398763] pci 0000:03:00.0: [17d3:1320] type 00 class 0x010000
[    0.398775] pci 0000:03:00.0: reg 10: [mem 0xb2540000-0xb255ffff 64bit]
[    0.398785] pci 0000:03:00.0: reg 18: [mem 0xb2500000-0xb253ffff 64bit]
[    0.398801] pci 0000:03:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.398828] pci 0000:03:00.0: supports D1
[    0.398830] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.400973] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.401079] pci 0000:00:05.0:   bridge window [mem 0xb2500000-0xb25fffff]
[    0.401112] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.401264] pci 0000:05:00.0: [8086:10c9] type 00 class 0x020000
[    0.401276] pci 0000:05:00.0: reg 10: [mem 0xb2420000-0xb243ffff]
[    0.401284] pci 0000:05:00.0: reg 14: [mem 0xb2000000-0xb23fffff]
[    0.401292] pci 0000:05:00.0: reg 18: [io  0x1020-0x103f]
[    0.401300] pci 0000:05:00.0: reg 1c: [mem 0xb24c4000-0xb24c7fff]
[    0.401321] pci 0000:05:00.0: reg 30: [mem 0xffc00000-0xffffffff pref]
[    0.401363] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.401398] pci 0000:05:00.0: reg 184: [mem 0xb2440000-0xb2443fff 64bit]
[    0.401414] pci 0000:05:00.0: reg 190: [mem 0xb2460000-0xb2463fff 64bit]
[    0.401442] pci 0000:05:00.1: [8086:10c9] type 00 class 0x020000
[    0.401453] pci 0000:05:00.1: reg 10: [mem 0xb2400000-0xb241ffff]
[    0.401461] pci 0000:05:00.1: reg 14: [mem 0xb1c00000-0xb1ffffff]
[    0.401469] pci 0000:05:00.1: reg 18: [io  0x1000-0x101f]
[    0.401477] pci 0000:05:00.1: reg 1c: [mem 0xb24c0000-0xb24c3fff]
[    0.401498] pci 0000:05:00.1: reg 30: [mem 0xffc00000-0xffffffff pref]
[    0.401540] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    0.401570] pci 0000:05:00.1: reg 184: [mem 0xb2480000-0xb2483fff 64bit]
[    0.401586] pci 0000:05:00.1: reg 190: [mem 0xb24a0000-0xb24a3fff 64bit]
[    0.404674] pci 0000:00:09.0: PCI bridge to [bus 05-07]
[    0.404779] pci 0000:00:09.0:   bridge window [io  0x1000-0x1fff]
[    0.404782] pci 0000:00:09.0:   bridge window [mem 0xb1c00000-0xb24fffff]
[    0.404821] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.404981] pci 0000:09:00.0: [102b:0522] type 00 class 0x030000
[    0.405001] pci 0000:09:00.0: reg 10: [mem 0xb0000000-0xb0ffffff pref]
[    0.405014] pci 0000:09:00.0: reg 14: [mem 0xb1800000-0xb1803fff]
[    0.405028] pci 0000:09:00.0: reg 18: [mem 0xb1000000-0xb17fffff]
[    0.405077] pci 0000:09:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.409257] pci 0000:00:1c.4: PCI bridge to [bus 09-09]
[    0.409365] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    0.409370] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    0.409424] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.409540] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.409542] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.409544] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.409546] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.409548] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xfdffffff] (subtractive decode)
[    0.409574] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.409937] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP1._PRT]
[    0.409982] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP3._PRT]
[    0.410048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP5._PRT]
[    0.410115] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP7._PRT]
[    0.410181] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MRP9._PRT]
[    0.410274] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.410340] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.410378] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    0.410523]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.410743]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.423934] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.424889] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.425837] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.426785] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.427734] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.428809] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.429756] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.430825] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.431938] vgaarb: device added: PCI:0000:09:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.432076] vgaarb: loaded
[    0.432171] vgaarb: bridge control possible 0000:09:00.0
[    0.432305] PCI: Using ACPI for IRQ routing
[    0.437777] PCI: Discovered peer bus ff
[    0.437875] PCI: root bus ff: using default resources
[    0.437877] PCI: Probing PCI hardware (bus ff)
[    0.437901] PCI host bridge to bus 0000:ff
[    0.438002] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.438109] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.438221] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    0.438239] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    0.438257] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    0.438272] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    0.438288] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    0.438303] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    0.438319] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    0.438334] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    0.438352] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    0.438368] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    0.438383] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    0.438399] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    0.438416] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    0.438431] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    0.438447] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    0.438462] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    0.438479] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    0.438495] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    0.438511] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    0.438527] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    0.438544] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    0.438560] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    0.438575] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    0.438591] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    0.439028] PCI: pci_cache_line_size set to 64 bytes
[    0.439167] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.439276] e820: reserve RAM buffer [mem 0x00094000-0x0009ffff]
[    0.439278] e820: reserve RAM buffer [mem 0x8c336000-0x8fffffff]
[    0.439387] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.439786] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.441916] Switching to clocksource hpet
[    0.443484] pnp: PnP ACPI init
[    0.443589] ACPI: bus type pnp registered
[    0.443978] pnp 00:00: [bus 00-fd]
[    0.443981] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.443982] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.443984] pnp 00:00: [io  0x0d00-0xffff window]
[    0.443986] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.443987] pnp 00:00: [mem 0x000c4000-0x000cbfff window]
[    0.443989] pnp 00:00: [mem 0xfed40000-0xfedfffff window]
[    0.443991] pnp 00:00: [mem 0xb0000000-0xfdffffff window]
[    0.443993] pnp 00:00: [mem 0x00000000 window]
[    0.444039] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.444048] pnp 00:01: [mem 0xfec00000-0xfecfffff]
[    0.444069] pnp 00:01: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.444275] pnp 00:02: [io  0x0000-0x000f]
[    0.444277] pnp 00:02: [io  0x0081-0x0083]
[    0.444279] pnp 00:02: [io  0x0087]
[    0.444280] pnp 00:02: [io  0x0089-0x008b]
[    0.444282] pnp 00:02: [io  0x008f]
[    0.444283] pnp 00:02: [io  0x00c0-0x00df]
[    0.444285] pnp 00:02: [dma 4]
[    0.444324] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.444333] pnp 00:03: [io  0x0070-0x0071]
[    0.444335] pnp 00:03: [io  0x0074-0x0077]
[    0.444342] pnp 00:03: [irq 8]
[    0.444378] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.444387] pnp 00:04: [io  0x00f0]
[    0.444392] pnp 00:04: [irq 13]
[    0.444429] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.444438] pnp 00:05: [io  0x0061]
[    0.444485] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.444525] pnp 00:06: [mem 0xfed00000-0xfed003ff]
[    0.444564] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.444575] pnp 00:07: [io  0x0500-0x057f]
[    0.444577] pnp 00:07: [io  0x0400-0x047f]
[    0.444579] pnp 00:07: [io  0x0092]
[    0.444580] pnp 00:07: [io  0x0010-0x001f]
[    0.444582] pnp 00:07: [io  0x0072-0x0073]
[    0.444583] pnp 00:07: [io  0x0080]
[    0.444585] pnp 00:07: [io  0x0084-0x0086]
[    0.444586] pnp 00:07: [io  0x0088]
[    0.444587] pnp 00:07: [io  0x008c-0x008e]
[    0.444589] pnp 00:07: [io  0x0090-0x009f]
[    0.444590] pnp 00:07: [io  0x0800-0x081f]
[    0.444592] pnp 00:07: [io  0x0ca2-0x0ca3]
[    0.444593] pnp 00:07: [io  0x0600-0x061f]
[    0.444595] pnp 00:07: [io  0x0880-0x0883]
[    0.444596] pnp 00:07: [io  0x0ca4-0x0ca5]
[    0.444598] pnp 00:07: [mem 0xfed1c000-0xfed3fffe]
[    0.444599] pnp 00:07: [mem 0xff000000-0xffffffff]
[    0.444601] pnp 00:07: [mem 0xfee00000-0xfeefffff]
[    0.444602] pnp 00:07: [mem 0xfe900000-0xfe90001f]
[    0.444604] pnp 00:07: [mem 0xfea00000-0xfea0001f]
[    0.444605] pnp 00:07: [mem 0xfed1b000-0xfed1bfff]
[    0.444702] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.444809] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.444915] system 00:07: [io  0x0800-0x081f] has been reserved
[    0.445021] system 00:07: [io  0x0ca2-0x0ca3] has been reserved
[    0.445127] system 00:07: [io  0x0600-0x061f] has been reserved
[    0.445235] system 00:07: [io  0x0880-0x0883] has been reserved
[    0.445341] system 00:07: [io  0x0ca4-0x0ca5] has been reserved
[    0.445447] system 00:07: [mem 0xfed1c000-0xfed3fffe] has been reserved
[    0.445556] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    0.445666] system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.445775] system 00:07: [mem 0xfe900000-0xfe90001f] has been reserved
[    0.445884] system 00:07: [mem 0xfea00000-0xfea0001f] has been reserved
[    0.446000] system 00:07: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    0.446109] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.446234] pnp 00:08: [io  0x03f8-0x03ff]
[    0.446240] pnp 00:08: [irq 4]
[    0.446311] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.446427] pnp 00:09: [io  0x02f8-0x02ff]
[    0.446432] pnp 00:09: [irq 3]
[    0.446502] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.446545] pnp 00:0a: [io  0x0ca2]
[    0.446547] pnp 00:0a: [io  0x0ca3]
[    0.446586] pnp 00:0a: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.446630] pnp: PnP ACPI: found 11 devices
[    0.446729] ACPI: ACPI bus type pnp unregistered
[    0.452954] pci 0000:03:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.453096] pci 0000:05:00.0: no compatible bridge window for [mem 0xffc00000-0xffffffff pref]
[    0.453237] pci 0000:05:00.1: no compatible bridge window for [mem 0xffc00000-0xffffffff pref]
[    0.453377] pci 0000:09:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.453553] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 08-08] add_size 1000
[    0.453556] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 08-08] add_size 200000
[    0.453559] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 08-08] add_size 200000
[    0.453566] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 09-09] add_size 1000
[    0.453586] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.453588] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.453590] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.453591] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.453595] pci 0000:00:09.0: BAR 15: assigned [mem 0xb2800000-0xb2ffffff pref]
[    0.453732] pci 0000:00:05.0: BAR 15: assigned [mem 0xb1900000-0xb19fffff pref]
[    0.453869] pci 0000:00:1c.0: BAR 14: assigned [mem 0xb1a00000-0xb1bfffff]
[    0.453984] pci 0000:00:1c.0: BAR 15: assigned [mem 0xb3000000-0xb31fffff 64bit pref]
[    0.454123] pci 0000:00:1c.0: BAR 13: assigned [io  0x4000-0x4fff]
[    0.454230] pci 0000:00:1c.4: BAR 13: assigned [io  0x5000-0x5fff]
[    0.454338] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.454442] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.454549] pci 0000:00:01.0:   bridge window [mem 0xb2600000-0xb26fffff]
[    0.454661] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.454771] pci 0000:03:00.0: BAR 6: assigned [mem 0xb1900000-0xb190ffff pref]
[    0.454907] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.455012] pci 0000:00:05.0:   bridge window [mem 0xb2500000-0xb25fffff]
[    0.455121] pci 0000:00:05.0:   bridge window [mem 0xb1900000-0xb19fffff pref]
[    0.455259] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.455368] pci 0000:05:00.0: BAR 6: assigned [mem 0xb2800000-0xb2bfffff pref]
[    0.463473] pci 0000:05:00.1: BAR 6: assigned [mem 0xb2c00000-0xb2ffffff pref]
[    0.463609] pci 0000:00:09.0: PCI bridge to [bus 05-07]
[    0.463712] pci 0000:00:09.0:   bridge window [io  0x1000-0x1fff]
[    0.463820] pci 0000:00:09.0:   bridge window [mem 0xb1c00000-0xb24fffff]
[    0.463930] pci 0000:00:09.0:   bridge window [mem 0xb2800000-0xb2ffffff pref]
[    0.464068] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.464171] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.464280] pci 0000:00:1c.0:   bridge window [mem 0xb1a00000-0xb1bfffff]
[    0.464390] pci 0000:00:1c.0:   bridge window [mem 0xb3000000-0xb31fffff 64bit pref]
[    0.464531] pci 0000:09:00.0: BAR 6: assigned [mem 0xb1810000-0xb181ffff pref]
[    0.464666] pci 0000:00:1c.4: PCI bridge to [bus 09-09]
[    0.464770] pci 0000:00:1c.4:   bridge window [io  0x5000-0x5fff]
[    0.464878] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    0.464988] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    0.465128] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.465292] pci 0000:00:1e.0: setting latency timer to 64
[    0.465295] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.465297] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.465299] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.465300] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[    0.465302] pci_bus 0000:00: resource 8 [mem 0xb0000000-0xfdffffff]
[    0.465304] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.465306] pci_bus 0000:01: resource 1 [mem 0xb2600000-0xb26fffff]
[    0.465307] pci_bus 0000:03: resource 1 [mem 0xb2500000-0xb25fffff]
[    0.465309] pci_bus 0000:03: resource 2 [mem 0xb1900000-0xb19fffff pref]
[    0.465311] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.465313] pci_bus 0000:05: resource 1 [mem 0xb1c00000-0xb24fffff]
[    0.465315] pci_bus 0000:05: resource 2 [mem 0xb2800000-0xb2ffffff pref]
[    0.465317] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    0.465318] pci_bus 0000:08: resource 1 [mem 0xb1a00000-0xb1bfffff]
[    0.465320] pci_bus 0000:08: resource 2 [mem 0xb3000000-0xb31fffff 64bit pref]
[    0.465322] pci_bus 0000:09: resource 0 [io  0x5000-0x5fff]
[    0.465324] pci_bus 0000:09: resource 1 [mem 0xb1000000-0xb18fffff]
[    0.465325] pci_bus 0000:09: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[    0.465327] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.465329] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.465331] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.465333] pci_bus 0000:0a: resource 7 [mem 0xfed40000-0xfedfffff]
[    0.465334] pci_bus 0000:0a: resource 8 [mem 0xb0000000-0xfdffffff]
[    0.465336] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.465338] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.465446] NET: Registered protocol family 2
[    0.465708] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.466597] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.468347] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.468695] TCP: Hash tables configured (established 524288 bind 65536)
[    0.468802] TCP: reno registered
[    0.468909] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.469051] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.469323] NET: Registered protocol family 1
[    0.469865] pci 0000:01:00.0: Disabling L0s
[    0.469982] pci 0000:01:00.1: Disabling L0s
[    0.470093] pci 0000:09:00.0: Boot video device
[    0.470129] PCI: CLS 64 bytes, default 64
[    0.470162] Unpacking initramfs...
[    0.687037] Freeing initrd memory: 11608k freed
[    0.688771] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.688882] software IO TLB [mem 0x88334000-0x8c333fff] (64MB) mapped at [ffff880088334000-ffff88008c333fff]
[    0.689869] audit: initializing netlink socket (disabled)
[    0.689986] type=2000 audit(1345058826.572:1): initialized
[    0.702684] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.703775] VFS: Disk quotas dquot_6.5.2
[    0.703910] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.704095] msgmni has been set to 15882
[    0.704341] alg: No test for stdrng (krng)
[    0.704476] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.704614] io scheduler noop registered
[    0.704712] io scheduler deadline registered
[    0.704845] io scheduler cfq registered (default)
[    0.705119] pcieport 0000:00:01.0: irq 64 for MSI/MSI-X
[    0.705205] pcieport 0000:00:03.0: irq 65 for MSI/MSI-X
[    0.705288] pcieport 0000:00:05.0: irq 66 for MSI/MSI-X
[    0.705392] pcieport 0000:00:07.0: irq 67 for MSI/MSI-X
[    0.705477] pcieport 0000:00:09.0: irq 68 for MSI/MSI-X
[    0.705566] pcieport 0000:00:1c.0: irq 69 for MSI/MSI-X
[    0.705671] pcieport 0000:00:1c.4: irq 70 for MSI/MSI-X
[    0.705767] aer 0000:00:01.0:pcie02: service driver aer loaded
[    0.705787] aer 0000:00:03.0:pcie02: service driver aer loaded
[    0.705808] aer 0000:00:05.0:pcie02: service driver aer loaded
[    0.705828] aer 0000:00:07.0:pcie02: service driver aer loaded
[    0.705848] aer 0000:00:09.0:pcie02: service driver aer loaded
[    0.705860] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.705969] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.706077] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.706186] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.706193] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    0.706303] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    0.706310] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    0.706419] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.706527] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    0.706534] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    0.706644] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    0.706651] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    0.706760] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.706867] pci 0000:05:00.1: Signaling PME through PCIe PME interrupt
[    0.706976] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    0.706992] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.707102] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.707117] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.707226] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    0.707335] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.707340] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.707492] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid 8086 ss_did 34dc
[    0.707649] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    0.707658] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 3a48 ss_vid 8086 ss_did 34dc
[    0.707811] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    0.707815] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.707922] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.708637] intel_idle: MWAIT substates: 0x1120
[    0.708638] intel_idle: v0.4 model 0x2C
[    0.708639] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.708750] ERST: Error Record Serialization Table (ERST) support is initialized.
[    0.709273] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    0.709441] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.729910] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.750392] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.771035] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.791544] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.791858] Linux agpgart interface v0.103
[    0.792107] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.793070] i8042: No controller found
[    0.793234] mousedev: PS/2 mouse device common for all mice
[    0.793368] rtc_cmos 00:03: RTC can wake from S4
[    0.793579] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.793708] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.793995] cpuidle: using governor ladder
[    0.794332] cpuidle: using governor menu
[    0.794491] drop_monitor: Initializing network drop monitor service
[    0.794673] TCP: cubic registered
[    0.797193] NET: Registered protocol family 10
[    0.798805] mip6: Mobile IPv6
[    0.798902] NET: Registered protocol family 17
[    0.799010] Key type dns_resolver registered
[    0.799495] PM: Hibernation image not present or could not be loaded.
[    0.799508] registered taskstats version 1
[    0.801002] rtc_cmos 00:03: setting system clock to 2012-08-15 19:27:06 UTC (1345058826)
[    0.803585] Freeing unused kernel memory: 580k freed
[    0.803767] Write protecting the kernel read-only data: 6144k
[    0.807922] Freeing unused kernel memory: 616k freed
[    0.811466] Freeing unused kernel memory: 636k freed
[    0.823537] udevd[91]: starting version 175
[    0.845113] dca service started, version 1.12.1
[    0.845846] igb: Intel(R) Gigabit Ethernet Network Driver - version 3.4.7-k
[    0.845959] igb: Copyright (c) 2007-2012 Intel Corporation.
[    0.846412] igb 0000:01:00.0: irq 71 for MSI/MSI-X
[    0.846420] igb 0000:01:00.0: irq 72 for MSI/MSI-X
[    0.846428] igb 0000:01:00.0: irq 73 for MSI/MSI-X
[    0.846435] igb 0000:01:00.0: irq 74 for MSI/MSI-X
[    0.846443] igb 0000:01:00.0: irq 75 for MSI/MSI-X
[    0.846450] igb 0000:01:00.0: irq 76 for MSI/MSI-X
[    0.846458] igb 0000:01:00.0: irq 77 for MSI/MSI-X
[    0.846466] igb 0000:01:00.0: irq 78 for MSI/MSI-X
[    0.846475] igb 0000:01:00.0: irq 79 for MSI/MSI-X
[    0.848456] SCSI subsystem initialized
[    0.850014] ACPI: bus type usb registered
[    0.850182] usbcore: registered new interface driver usbfs
[    0.850304] usbcore: registered new interface driver hub
[    0.850907] usbcore: registered new device driver usb
[    0.851492] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.851653] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.851657] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.851770] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.851936] ehci_hcd 0000:00:1a.7: debug port 1
[    0.853379] libata version 3.00 loaded.
[    0.854805] mvsas 0000:03:00.0: mvsas: driver version 0.8.16
[    0.855148] mvsas 0000:03:00.0: mvsas: PCI-E x8, Bandwidth Usage: 5.0 Gbps
[    0.855905] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.855929] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xb2721000
[    0.864960] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.865110] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.865224] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.865364] usb usb1: Product: EHCI Host Controller
[    0.865470] usb usb1: Manufacturer: Linux 3.5-trunk-amd64 ehci_hcd
[    0.865579] usb usb1: SerialNumber: 0000:00:1a.7
[    0.865850] hub 1-0:1.0: USB hub found
[    0.865955] hub 1-0:1.0: 6 ports detected
[    0.866159] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.866162] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.866269] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.866425] ehci_hcd 0000:00:1d.7: debug port 1
[    0.870391] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.870404] ehci_hcd 0000:00:1d.7: irq 16, io mem 0xb2720000
[    0.880921] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.881043] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.881152] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.881287] usb usb2: Product: EHCI Host Controller
[    0.881389] usb usb2: Manufacturer: Linux 3.5-trunk-amd64 ehci_hcd
[    0.881496] usb usb2: SerialNumber: 0000:00:1d.7
[    0.881778] hub 2-0:1.0: USB hub found
[    0.881881] hub 2-0:1.0: 6 ports detected
[    0.882094] ata_piix 0000:00:1f.2: version 2.13
[    0.882113] ata_piix 0000:00:1f.2: MAP [
[    0.882217]  P0 P2 P1 P3 ]
[    1.015257] uhci_hcd: USB Universal Host Controller Interface driver
[    1.036584] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.036978] scsi1 : ata_piix
[    1.037966] scsi2 : ata_piix
[    1.038462] ata1: SATA max UDMA/133 cmd 0x3138 ctl 0x314c bmdma 0x3110 irq 18
[    1.038575] ata2: SATA max UDMA/133 cmd 0x3130 ctl 0x3148 bmdma 0x3118 irq 18
[    1.038706] ata_piix 0000:00:1f.5: MAP [
[    1.038806]  P0 -- P1 -- ]
[    1.039140] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.039142] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:1e:67:46:e7:8c
[    1.039219] igb 0000:01:00.0: eth0: PBA No: 1040FF-0FF
[    1.039221] igb 0000:01:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.039808] igb 0000:01:00.1: irq 80 for MSI/MSI-X
[    1.039814] igb 0000:01:00.1: irq 81 for MSI/MSI-X
[    1.039819] igb 0000:01:00.1: irq 82 for MSI/MSI-X
[    1.039824] igb 0000:01:00.1: irq 83 for MSI/MSI-X
[    1.039829] igb 0000:01:00.1: irq 84 for MSI/MSI-X
[    1.039834] igb 0000:01:00.1: irq 85 for MSI/MSI-X
[    1.039839] igb 0000:01:00.1: irq 86 for MSI/MSI-X
[    1.039844] igb 0000:01:00.1: irq 87 for MSI/MSI-X
[    1.039849] igb 0000:01:00.1: irq 88 for MSI/MSI-X
[    1.176166] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.192088] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.192489] scsi3 : ata_piix
[    1.192852] scsi4 : ata_piix
[    1.193307] ata3: SATA max UDMA/133 cmd 0x3128 ctl 0x3144 bmdma 0x30f0 irq 21
[    1.193419] ata4: SATA max UDMA/133 cmd 0x3120 ctl 0x3140 bmdma 0x30f8 irq 21
[    1.193612] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.193617] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.193733] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.193895] uhci_hcd 0000:00:1a.0: irq 19, io base 0x000030c0
[    1.194030] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.194140] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.194277] usb usb3: Product: UHCI Host Controller
[    1.194379] usb usb3: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.194485] usb usb3: SerialNumber: 0000:00:1a.0
[    1.194781] hub 3-0:1.0: USB hub found
[    1.194883] hub 3-0:1.0: 2 ports detected
[    1.195050] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.195053] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.195159] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.195315] uhci_hcd 0000:00:1a.1: irq 19, io base 0x000030a0
[    1.195443] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.195552] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.203678] usb usb4: Product: UHCI Host Controller
[    1.203781] usb usb4: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.203887] usb usb4: SerialNumber: 0000:00:1a.1
[    1.204264] hub 4-0:1.0: USB hub found
[    1.204368] hub 4-0:1.0: 2 ports detected
[    1.204540] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.204543] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.204648] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.204807] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00003080
[    1.204936] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.205047] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.205183] usb usb5: Product: UHCI Host Controller
[    1.205284] usb usb5: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.205391] usb usb5: SerialNumber: 0000:00:1a.2
[    1.205669] hub 5-0:1.0: USB hub found
[    1.205773] hub 5-0:1.0: 2 ports detected
[    1.205943] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.205946] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.206053] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.206211] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003060
[    1.206341] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.206451] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.206586] usb usb6: Product: UHCI Host Controller
[    1.206688] usb usb6: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.206795] usb usb6: SerialNumber: 0000:00:1d.0
[    1.207078] hub 6-0:1.0: USB hub found
[    1.207181] hub 6-0:1.0: 2 ports detected
[    1.207358] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.207361] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.207468] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.207625] uhci_hcd 0000:00:1d.1: irq 16, io base 0x00003040
[    1.207754] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.207863] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.208006] usb usb7: Product: UHCI Host Controller
[    1.208111] usb usb7: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.208221] usb usb7: SerialNumber: 0000:00:1d.1
[    1.208619] hub 7-0:1.0: USB hub found
[    1.208722] hub 7-0:1.0: 2 ports detected
[    1.208891] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.208894] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.209000] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.209155] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00003020
[    1.209284] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.209394] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.209530] usb usb8: Product: UHCI Host Controller
[    1.209632] usb usb8: Manufacturer: Linux 3.5-trunk-amd64 uhci_hcd
[    1.209738] usb usb8: SerialNumber: 0000:00:1d.2
[    1.210039] hub 8-0:1.0: USB hub found
[    1.210146] hub 8-0:1.0: 2 ports detected
[    1.228293] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[    1.228406] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:1e:67:46:e7:8d
[    1.228590] igb 0000:01:00.1: eth1: PBA No: 1040FF-0FF
[    1.228693] igb 0000:01:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.229080] igb 0000:05:00.0: irq 89 for MSI/MSI-X
[    1.229085] igb 0000:05:00.0: irq 90 for MSI/MSI-X
[    1.229090] igb 0000:05:00.0: irq 91 for MSI/MSI-X
[    1.229095] igb 0000:05:00.0: irq 92 for MSI/MSI-X
[    1.229100] igb 0000:05:00.0: irq 93 for MSI/MSI-X
[    1.229105] igb 0000:05:00.0: irq 94 for MSI/MSI-X
[    1.229110] igb 0000:05:00.0: irq 95 for MSI/MSI-X
[    1.229115] igb 0000:05:00.0: irq 96 for MSI/MSI-X
[    1.229121] igb 0000:05:00.0: irq 97 for MSI/MSI-X
[    1.312206] usb 1-1: New USB device found, idVendor=0951, idProduct=1653
[    1.312321] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.312431] usb 1-1: Product: DT 100 G2
[    1.312529] usb 1-1: Manufacturer: Kingston
[    1.312629] usb 1-1: SerialNumber: 001372982D6ABBB1C5760052
[    1.316596] usbcore: registered new interface driver uas
[    1.419894] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.420010] igb 0000:05:00.0: eth2: (PCIe:2.5Gb/s:Width x4) 90:e2:ba:21:64:5e
[    1.420198] igb 0000:05:00.0: eth2: PBA No: E43709-006
[    1.420309] igb 0000:05:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    1.420730] igb 0000:05:00.1: irq 98 for MSI/MSI-X
[    1.420736] igb 0000:05:00.1: irq 99 for MSI/MSI-X
[    1.420743] igb 0000:05:00.1: irq 100 for MSI/MSI-X
[    1.420748] igb 0000:05:00.1: irq 101 for MSI/MSI-X
[    1.420753] igb 0000:05:00.1: irq 102 for MSI/MSI-X
[    1.420758] igb 0000:05:00.1: irq 103 for MSI/MSI-X
[    1.420763] igb 0000:05:00.1: irq 104 for MSI/MSI-X
[    1.420768] igb 0000:05:00.1: irq 105 for MSI/MSI-X
[    1.420772] igb 0000:05:00.1: irq 106 for MSI/MSI-X
[    1.521952] ata4: SATA link down (SStatus 0 SControl 300)
[    1.532682] ata3: SATA link down (SStatus 4 SControl 300)
[    1.611305] igb 0000:05:00.1: Intel(R) Gigabit Ethernet Network Connection
[    1.611416] igb 0000:05:00.1: eth3: (PCIe:2.5Gb/s:Width x4) 90:e2:ba:21:64:5f
[    1.611600] igb 0000:05:00.1: eth3: PBA No: E43709-006
[    1.611708] igb 0000:05:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    1.682833] Refined TSC clocksource calibration: 2666.634 MHz.
[    1.682952] Switching to clocksource tsc
[    1.685559] ata2.00: SATA link down (SStatus 0 SControl 300)
[    1.685676] ata2.01: SATA link down (SStatus 0 SControl 300)
[    1.696487] ata1.00: SATA link down (SStatus 0 SControl 300)
[    1.696603] ata1.01: SATA link down (SStatus 0 SControl 300)
[    1.697915] Initializing USB Mass Storage driver...
[    1.698130] scsi5 : usb-storage 1-1:1.0
[    1.698311] usbcore: registered new interface driver usb-storage
[    1.698419] USB Mass Storage support registered.
[    1.974114] usb 4-1: new low-speed USB device number 2 using uhci_hcd
[    2.300603] usb 4-1: New USB device found, idVendor=046d, idProduct=c30e
[    2.300714] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.300823] usb 4-1: Product: HID compliant keyboard
[    2.300926] usb 4-1: Manufacturer: Logitech
[    2.473214] usbcore: registered new interface driver usbhid
[    2.473323] usbhid: USB HID core driver
[    2.548571] usb 5-1: new full-speed USB device number 2 using uhci_hcd
[    2.694370] scsi 5:0:0:0: Direct-Access     Kingston DT 100 G2        PMAP PQ: 0 ANSI: 0 CCS
[    2.701823] sd 5:0:0:0: [sda] 7612032 512-byte logical blocks: (3.89 GB/3.62 GiB)
[    2.702592] sd 5:0:0:0: [sda] Write Protect is off
[    2.702696] sd 5:0:0:0: [sda] Mode Sense: 23 00 00 00
[    2.703227] sd 5:0:0:0: Attached scsi generic sg0 type 0
[    2.703313] sd 5:0:0:0: [sda] No Caching mode page present
[    2.703314] sd 5:0:0:0: [sda] Assuming drive cache: write through
[    2.707051] sd 5:0:0:0: [sda] No Caching mode page present
[    2.707160] sd 5:0:0:0: [sda] Assuming drive cache: write through
[    2.708471]  sda: sda1
[    2.711330] sd 5:0:0:0: [sda] No Caching mode page present
[    2.711498] sd 5:0:0:0: [sda] Assuming drive cache: write through
[    2.711605] sd 5:0:0:0: [sda] Attached SCSI removable disk
[    2.713020] usb 5-1: New USB device found, idVendor=046b, idProduct=ff10
[    2.713135] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.713245] usb 5-1: Product: Virtual Keyboard and Mouse
[    2.713349] usb 5-1: Manufacturer: American Megatrends Inc.
[    2.713453] usb 5-1: SerialNumber: serial
[    8.226628] scsi0 : mvsas
[    8.227753] sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5001b4d50fc8103f)
[    8.227757] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map 1
[    8.237674] sas: phy1 matched wide port0
[    8.237695] sas: phy-0:1 added to port-0:0, phy_mask:0x3 (5001b4d50fc8103f)
[    8.237697] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map 3
[    8.257495] sas: phy2 matched wide port0
[    8.257500] sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5001b4d50fc8103f)
[    8.257503] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map 7
[    8.287193] sas: phy3 matched wide port0
[    8.287197] sas: phy-0:3 added to port-0:0, phy_mask:0xf (5001b4d50fc8103f)
[    8.287198] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map f
[    8.326783] sas: phy0 matched wide port0
[    8.326786] sas: phy-0:4 added to port-0:0, phy_mask:0xf (5001b4d50fc8103f)
[    8.326788] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map f
[    8.366372] sas: phy1 matched wide port0
[    8.366375] sas: phy-0:5 added to port-0:0, phy_mask:0xf (5001b4d50fc8103f)
[    8.366377] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map f
[    8.405961] sas: phy2 matched wide port0
[    8.405964] sas: phy-0:6 added to port-0:0, phy_mask:0xf (5001b4d50fc8103f)
[    8.405966] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map f
[    8.445550] sas: phy3 matched wide port0
[    8.445553] sas: phy-0:7 added to port-0:0, phy_mask:0xf (5001b4d50fc8103f)
[    8.445555] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1212:set wide port phy map f
[    8.485186] sas: DOING DISCOVERY on port 0, pid:294
[    8.485590] sas: ex 5001b4d50fc8103f phy00:U:9 attached: 5001b4d50fc81000 (stp)
[    8.485746] sas: ex 5001b4d50fc8103f phy01:U:9 attached: 5001b4d50fc81001 (stp)
[    8.485906] sas: ex 5001b4d50fc8103f phy02:U:9 attached: 5001b4d50fc81002 (stp)
[    8.486130] sas: ex 5001b4d50fc8103f phy03:U:9 attached: 5001b4d50fc81003 (stp)
[    8.486259] sas: ex 5001b4d50fc8103f phy04:D:0 attached: 0000000000000000 (no device)
[    8.486361] sas: ex 5001b4d50fc8103f phy05:D:0 attached: 0000000000000000 (no device)
[    8.486446] sas: ex 5001b4d50fc8103f phy06:D:0 attached: 0000000000000000 (no device)
[    8.486524] sas: ex 5001b4d50fc8103f phy07:D:0 attached: 0000000000000000 (no device)
[    8.486608] sas: ex 5001b4d50fc8103f phy08:D:0 attached: 0000000000000000 (no device)
[    8.486705] sas: ex 5001b4d50fc8103f phy09:D:0 attached: 0000000000000000 (no device)
[    8.486792] sas: ex 5001b4d50fc8103f phy10:D:0 attached: 0000000000000000 (no device)
[    8.486881] sas: ex 5001b4d50fc8103f phy11:D:0 attached: 0000000000000000 (no device)
[    8.486944] sas: ex 5001b4d50fc8103f phy12:D:0 attached: 0000000000000000 (no device)
[    8.487009] sas: ex 5001b4d50fc8103f phy13:D:0 attached: 0000000000000000 (no device)
[    8.487090] sas: ex 5001b4d50fc8103f phy14:D:0 attached: 0000000000000000 (no device)
[    8.487159] sas: ex 5001b4d50fc8103f phy15:D:0 attached: 0000000000000000 (no device)
[    8.487271] sas: ex 5001b4d50fc8103f phy16:U:0 attached: 0000000000000000 (no device)
[    8.487366] sas: ex 5001b4d50fc8103f phy17:U:0 attached: 0000000000000000 (no device)
[    8.487475] sas: ex 5001b4d50fc8103f phy18:U:0 attached: 0000000000000000 (no device)
[    8.487571] sas: ex 5001b4d50fc8103f phy19:U:0 attached: 0000000000000000 (no device)
[    8.487649] sas: ex 5001b4d50fc8103f phy20:D:0 attached: 0000000000000000 (no device)
[    8.487731] sas: ex 5001b4d50fc8103f phy21:D:0 attached: 0000000000000000 (no device)
[    8.487808] sas: ex 5001b4d50fc8103f phy22:D:0 attached: 0000000000000000 (no device)
[    8.487885] sas: ex 5001b4d50fc8103f phy23:D:0 attached: 0000000000000000 (no device)
[    8.488002] sas: ex 5001b4d50fc8103f phy24:S:A attached: 5005043011ab0000 (host)
[    8.488105] sas: ex 5001b4d50fc8103f phy25:S:A attached: 5005043011ab0000 (host)
[    8.488216] sas: ex 5001b4d50fc8103f phy26:S:A attached: 5005043011ab0000 (host)
[    8.488314] sas: ex 5001b4d50fc8103f phy27:S:A attached: 5005043011ab0000 (host)
[    8.488428] sas: ex 5001b4d50fc8103f phy28:U:9 attached: 5001b4d50fc8101c (stp)
[    8.488529] sas: ex 5001b4d50fc8103f phy29:U:9 attached: 5001b4d50fc8101d (stp)
[    8.488642] sas: ex 5001b4d50fc8103f phy30:U:9 attached: 5001b4d50fc8101e (stp)
[    8.488743] sas: ex 5001b4d50fc8103f phy31:U:9 attached: 5001b4d50fc8101f (stp)
[    8.488826] sas: ex 5001b4d50fc8103f phy32:D:0 attached: 0000000000000000 (no device)
[    8.488914] sas: ex 5001b4d50fc8103f phy33:D:0 attached: 0000000000000000 (no device)
[    8.488999] sas: ex 5001b4d50fc8103f phy34:D:0 attached: 0000000000000000 (no device)
[    8.489113] sas: ex 5001b4d50fc8103f phy35:D:0 attached: 0000000000000000 (no device)
[    8.489230] sas: ex 5001b4d50fc8103f phy36:D:A attached: 5001b4d50fc8103d (host+target)
[    8.489321] sas: ex 5001b4d50fc8103f phy37:D:0 attached: 0000000000000000 (no device)
[    8.490124] sas: DONE DISCOVERY on port 0, pid:294, result:0
[    8.490189] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    8.490204] sas: ata5: end_device-0:0:0: dev error handler
[    8.490206] sas: ata6: end_device-0:0:1: dev error handler
[    8.490209] sas: ata7: end_device-0:0:2: dev error handler
[    8.490214] sas: ata8: end_device-0:0:3: dev error handler
[    8.490420] sas: ata9: end_device-0:0:28: dev error handler
[    8.490530] sas: ata10: end_device-0:0:29: dev error handler
[    8.490627] sas: ata11: end_device-0:0:30: dev error handler
[    8.490712] sas: ata12: end_device-0:0:31: dev error handler
[    8.653570] ISO 9660 Extensions: Microsoft Joliet Level 3
[    8.657937] ISO 9660 Extensions: RRIP_1991A
[    8.665709] aufs: module is from the staging directory, the quality is unknown, you have been warned.
[    8.668500] aufs 3.5-20120730
[    8.678166] loop: module loaded
[    8.744397] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   13.631430] ata12.00: qc timeout (cmd 0xec)
[   13.631432] ata6.00: qc timeout (cmd 0xec)
[   13.631438] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631457] ata10.00: qc timeout (cmd 0xec)
[   13.631458] ata8.00: qc timeout (cmd 0xec)
[   13.631460] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631461] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631469] ata5.00: qc timeout (cmd 0xec)
[   13.631471] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631492] ata9.00: qc timeout (cmd 0xec)
[   13.631494] ata7.00: qc timeout (cmd 0xec)
[   13.631496] ata11.00: qc timeout (cmd 0xec)
[   13.631498] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631499] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.631500] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.632989] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000EF,  slot [4].
[   13.632996] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   13.632998] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   13.633111] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000EE,  slot [0].
[   13.633118] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   13.816662] udevd[977]: starting version 175
[   13.866206] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[   13.866299] ACPI: Sleep Button [SLPB]
[   13.866412] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   13.866500] ACPI: Power Button [PWRF]
[   13.866635] ACPI: Requesting acpi_cpufreq
[   13.914356] EDAC MC: Ver: 2.1.0
[   13.935314] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   13.935461] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   13.935791] EDAC i7core: Driver loaded, 1 memory controller(s) found.
[   13.953984] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input2
[   13.954178] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.1-1/input0
[   13.961713] ACPI Warning: 0x0000000000000460-0x000000000000047f SystemIO conflicts with Region \_GPE.TCOS 1 (20120320/utaddress-251)
[   13.961988] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.962134] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[   13.962241] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \GPE0 1 (20120320/utaddress-251)
[   13.962513] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.962665] ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts with Region \_SI_.SIOR 1 (20120320/utaddress-251)
[   13.962938] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.963084] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   13.971446] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   13.971654] ioatdma 0000:00:16.0: irq 107 for MSI/MSI-X
[   13.971822] igb 0000:01:00.0: DCA enabled
[   13.971945] igb 0000:01:00.1: DCA enabled
[   13.972112] ioatdma 0000:00:16.1: irq 108 for MSI/MSI-X
[   13.972262] igb 0000:05:00.0: DCA enabled
[   13.972395] igb 0000:05:00.1: DCA enabled
[   13.972570] ioatdma 0000:00:16.2: irq 109 for MSI/MSI-X
[   13.972761] ioatdma 0000:00:16.3: irq 110 for MSI/MSI-X
[   13.972959] ioatdma 0000:00:16.4: irq 111 for MSI/MSI-X
[   13.973144] ioatdma 0000:00:16.5: irq 112 for MSI/MSI-X
[   13.973329] ioatdma 0000:00:16.6: irq 113 for MSI/MSI-X
[   13.973513] ioatdma 0000:00:16.7: irq 114 for MSI/MSI-X
[   13.983749] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   13.983961] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/input/input4
[   13.984167] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.1-1/input1
[   13.984458] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input5
[   13.984668] hid-generic 0003:046B:FF10.0003: input,hidraw2: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-1/input0
[   13.984979] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input6
[   13.985211] hid-generic 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-1/input1
[   13.987656] microcode: CPU0 sig=0x206c2, pf=0x1, revision=0x15
[   14.076851] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[   14.079824] microcode: CPU1 sig=0x206c2, pf=0x1, revision=0x15
[   14.081404] microcode: CPU2 sig=0x206c2, pf=0x1, revision=0x15
[   14.083109] microcode: CPU3 sig=0x206c2, pf=0x1, revision=0x15
[   14.084816] microcode: CPU4 sig=0x206c2, pf=0x1, revision=0x15
[   14.086329] microcode: CPU5 sig=0x206c2, pf=0x1, revision=0x15
[   14.088434] microcode: CPU6 sig=0x206c2, pf=0x1, revision=0x15
[   14.090046] microcode: CPU7 sig=0x206c2, pf=0x1, revision=0x15
[   14.091595] Error: Driver 'pcspkr' is already registered, aborting...
[   14.091698] microcode: CPU8 sig=0x206c2, pf=0x1, revision=0x15
[   14.093145] microcode: CPU9 sig=0x206c2, pf=0x1, revision=0x15
[   14.094876] microcode: CPU10 sig=0x206c2, pf=0x1, revision=0x15
[   14.096447] microcode: CPU11 sig=0x206c2, pf=0x1, revision=0x15
[   14.097888] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.120919] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   15.630214] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[1]:rc= 0
[   15.630220] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[8]:rc= 0
[   15.630225] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[3]:rc= 0
[   15.630230] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[5]:rc= 0
[   15.630234] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[7]:rc= 0
[   15.630288] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[6]:rc= 0
[   15.630292] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[2]:rc= 0
[   15.630295] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[4]:rc= 0
[   15.786251] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000ED,  slot [1].
[   15.786268] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.786675] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000EB,  slot [2].
[   15.786691] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.787013] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000E7,  slot [3].
[   15.787024] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.787763] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000DF,  slot [5].
[   15.787780] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.788205] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BF,  slot [6].
[   15.788222] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.788499] sas: ata: ex 5001b4d50fc8103f phy31:U:9 attached: 5001b4d50fc8101f (no device)
[   15.841826] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000007F,  slot [7].
[   15.841842] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   15.842111] sas: ata: ex 5001b4d50fc8103f phy31:U:9 attached: 5001b4d50fc8101f (stp)
[   18.468923] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   18.580086] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
[   18.672162] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.743314] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   21.670845] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   21.671987] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.759687] ata9.00: qc timeout (cmd 0xec)
[   25.759690] ata10.00: qc timeout (cmd 0xec)
[   25.759697] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759724] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BF,  slot [6].
[   25.759747] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   25.759761] ata8.00: qc timeout (cmd 0xec)
[   25.759764] ata7.00: qc timeout (cmd 0xec)
[   25.759768] ata6.00: qc timeout (cmd 0xec)
[   25.759772] ata5.00: qc timeout (cmd 0xec)
[   25.759775] ata11.00: qc timeout (cmd 0xec)
[   25.759777] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759779] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759781] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759783] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759785] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.759981] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BE,  slot [0].
[   25.759997] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   25.761061] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   25.815591] ata12.00: qc timeout (cmd 0xec)
[   25.815698] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   27.758393] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[7]:rc= 0
[   27.758417] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[5]:rc= 0
[   27.758470] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[1]:rc= 0
[   27.758474] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[6]:rc= 0
[   27.758478] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[3]:rc= 0
[   27.758482] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[4]:rc= 0
[   27.758485] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[2]:rc= 0
[   27.814343] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[8]:rc= 0
[   27.914438] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BD,  slot [1].
[   27.914455] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   27.914886] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BB,  slot [2].
[   27.914900] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   27.915279] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000B7,  slot [3].
[   27.915291] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   27.915652] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000AF,  slot [4].
[   27.915662] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   27.916013] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000009F,  slot [5].
[   27.916023] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   27.970007] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000007F,  slot [7].
[   27.970024] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   57.835530] ata6.00: qc timeout (cmd 0xec)
[   57.835533] ata5.00: qc timeout (cmd 0xec)
[   57.835539] ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835561] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BF,  slot [6].
[   57.835571] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   57.835612] ata9.00: qc timeout (cmd 0xec)
[   57.835616] ata10.00: qc timeout (cmd 0xec)
[   57.835619] ata11.00: qc timeout (cmd 0xec)
[   57.835623] ata8.00: qc timeout (cmd 0xec)
[   57.835626] ata7.00: qc timeout (cmd 0xec)
[   57.835628] ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835630] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835632] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835634] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835636] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.835813] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BE,  slot [0].
[   57.835829] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[   57.836905] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   57.891447] ata12.00: qc timeout (cmd 0xec)
[   57.891554] ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   59.834296] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[3]:rc= 0
[   59.834302] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[2]:rc= 0
[   59.834374] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[1]:rc= 0
[   59.834378] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[4]:rc= 0
[   59.834381] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[6]:rc= 0
[   59.834385] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[5]:rc= 0
[   59.834389] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[7]:rc= 0
[   59.890201] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[8]:rc= 0
[   60.046140] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[   80.767359] scsi 0:0:8:0: command ffff880263890e80 timed out
[   80.767426] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[   80.767430] sas: trying to find task 0xffff880265587bc0
[   80.767432] sas: sas_scsi_find_task: aborting task 0xffff880265587bc0
[   80.767510] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BD,  slot [1].
[   80.767515] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  100.747023] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  100.747029] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  100.747032] sas: sas_scsi_find_task: querying task 0xffff880265587bc0
[  100.747107] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000BB,  slot [2].
[  100.747112] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  120.726621] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  120.726626] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  120.726628] sas: sas_scsi_find_task: task 0xffff880265587bc0 failed to abort
[  120.726630] sas: task 0xffff880265587bc0 is not at LU: I_T recover
[  120.726633] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  120.726708] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000B7,  slot [3].
[  120.726725] sas: smp_execute_task: task to dev 5001b4d50fc8103f response: 0x0 status 0x2
[  122.725362] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  122.725371] sas: I_T 5001b4d50fc8103d recovered
[  122.725448] sas: ata5: end_device-0:0:0: dev error handler
[  122.725462] sas: ata6: end_device-0:0:1: dev error handler
[  122.725468] sas: ata7: end_device-0:0:2: dev error handler
[  122.725473] sas: ata8: end_device-0:0:3: dev error handler
[  122.725478] sas: ata9: end_device-0:0:28: dev error handler
[  122.725482] sas: ata10: end_device-0:0:29: dev error handler
[  122.725487] sas: ata11: end_device-0:0:30: dev error handler
[  122.725492] sas: ata12: end_device-0:0:31: dev error handler
[  122.725530] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  122.730161] scsi 0:0:8:0: Enclosure         Areca    ARC-8017-.01.14. 0114 PQ: 0 ANSI: 5
[  153.536417] scsi 0:0:8:0: command ffff880263890e80 timed out
[  153.536485] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  153.536489] sas: trying to find task 0xffff880265587bc0
[  153.536491] sas: sas_scsi_find_task: aborting task 0xffff880265587bc0
[  153.536564] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 000000AF,  slot [4].
[  153.536569] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  173.516128] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  173.516132] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  173.516135] sas: sas_scsi_find_task: querying task 0xffff880265587bc0
[  173.516209] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000009F,  slot [5].
[  173.516214] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  193.495701] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  193.495705] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  193.495708] sas: sas_scsi_find_task: task 0xffff880265587bc0 failed to abort
[  193.495710] sas: task 0xffff880265587bc0 is not at LU: I_T recover
[  193.495712] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  195.494461] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  195.494472] sas: I_T 5001b4d50fc8103d recovered
[  195.494547] sas: ata5: end_device-0:0:0: dev error handler
[  195.494561] sas: ata6: end_device-0:0:1: dev error handler
[  195.494567] sas: ata7: end_device-0:0:2: dev error handler
[  195.494572] sas: ata8: end_device-0:0:3: dev error handler
[  195.494577] sas: ata9: end_device-0:0:28: dev error handler
[  195.494582] sas: ata10: end_device-0:0:29: dev error handler
[  195.494587] sas: ata11: end_device-0:0:30: dev error handler
[  195.494591] sas: ata12: end_device-0:0:31: dev error handler
[  195.494630] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  226.433204] scsi 0:0:8:0: command ffff880263890e80 timed out
[  226.433273] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  226.433277] sas: trying to find task 0xffff880265587bc0
[  226.433280] sas: sas_scsi_find_task: aborting task 0xffff880265587bc0
[  226.433355] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000007F,  slot [7].
[  226.433361] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  226.433456] sas: task done but aborted
[  226.433460] sas: sas_scsi_find_task: task 0xffff880265587bc0 is done
[  226.433463] sas: sas_eh_handle_sas_errors: task 0xffff880265587bc0 is done
[  226.433535] sas: ata5: end_device-0:0:0: dev error handler
[  226.433549] sas: ata6: end_device-0:0:1: dev error handler
[  226.433555] sas: ata7: end_device-0:0:2: dev error handler
[  226.433560] sas: ata8: end_device-0:0:3: dev error handler
[  226.433565] sas: ata9: end_device-0:0:28: dev error handler
[  226.433569] sas: ata10: end_device-0:0:29: dev error handler
[  226.433574] sas: ata11: end_device-0:0:30: dev error handler
[  226.433579] sas: ata12: end_device-0:0:31: dev error handler
[  226.433617] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  226.437271] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_94xx.c 626:command active 0000003F,  slot [6].
[  226.437276] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1781:reuse same slot, retry command.
[  226.437782] sas: broadcast received: 0
[  226.437786] sas: broadcast received: 0
[  226.437788] sas: broadcast received: 0
[  226.437789] sas: broadcast received: 0
[  226.437791] sas: REVALIDATING DOMAIN on port 0, pid:294
[  226.438053] scsi 0:0:8:0: Attached scsi generic sg1 type 13
[  226.438305] sas: Expander phy change count has changed
[  226.438558] sas: ex 5001b4d50fc8103f phy0 originated BROADCAST(CHANGE)
[  226.439058] sas: ex 5001b4d50fc8103f phy 0x0 broadcast flutter
[  226.439280] sas: ex 5001b4d50fc8103f phy1 originated BROADCAST(CHANGE)
[  226.439715] sas: ex 5001b4d50fc8103f phy 0x1 broadcast flutter
[  226.439935] sas: ex 5001b4d50fc8103f phy2 originated BROADCAST(CHANGE)
[  226.440365] sas: ex 5001b4d50fc8103f phy 0x2 broadcast flutter
[  226.440581] sas: ex 5001b4d50fc8103f phy3 originated BROADCAST(CHANGE)
[  226.441015] sas: ex 5001b4d50fc8103f phy 0x3 broadcast flutter
[  226.446562] sas: ex 5001b4d50fc8103f phy28 originated BROADCAST(CHANGE)
[  226.446997] sas: ex 5001b4d50fc8103f phy 0x1c broadcast flutter
[  226.447213] sas: ex 5001b4d50fc8103f phy29 originated BROADCAST(CHANGE)
[  226.447651] sas: ex 5001b4d50fc8103f phy 0x1d broadcast flutter
[  226.447868] sas: ex 5001b4d50fc8103f phy30 originated BROADCAST(CHANGE)
[  226.448300] sas: ex 5001b4d50fc8103f phy 0x1e broadcast flutter
[  226.448518] sas: ex 5001b4d50fc8103f phy31 originated BROADCAST(CHANGE)
[  226.448949] sas: ex 5001b4d50fc8103f phy 0x1f broadcast flutter
[  226.449882] sas: ex 5001b4d50fc8103f phy36 originated BROADCAST(CHANGE)
[  226.450340] sas: ex 5001b4d50fc8103f phy 0x24 broadcast flutter
[  226.450554] sas: done REVALIDATING DOMAIN on port 0, pid:294, res 0x0
[  226.450556] sas: broadcast received: 0
[  226.450558] sas: broadcast received: 0
[  226.450560] sas: broadcast received: 0
[  226.450561] sas: broadcast received: 0
[  226.450562] sas: REVALIDATING DOMAIN on port 0, pid:294
[  226.450756] sas: done REVALIDATING DOMAIN on port 0, pid:294, res 0x0
[  257.328203] scsi 0:0:8:0: command ffff880263890080 timed out
[  257.328276] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  257.328281] sas: trying to find task 0xffff88025e1fce00
[  257.328283] sas: sas_scsi_find_task: aborting task 0xffff88025e1fce00
[  277.307840] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  277.307845] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  277.307848] sas: sas_scsi_find_task: querying task 0xffff88025e1fce00
[  297.287432] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  297.287437] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  297.287439] sas: sas_scsi_find_task: task 0xffff88025e1fce00 failed to abort
[  297.287441] sas: task 0xffff88025e1fce00 is not at LU: I_T recover
[  297.287443] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  299.286191] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  299.286200] sas: I_T 5001b4d50fc8103d recovered
[  299.286238] sas: broadcast received: 0
[  299.286244] sas: ata5: end_device-0:0:0: dev error handler
[  299.286258] sas: ata6: end_device-0:0:1: dev error handler
[  299.286263] sas: ata7: end_device-0:0:2: dev error handler
[  299.286268] sas: ata8: end_device-0:0:3: dev error handler
[  299.286272] sas: ata9: end_device-0:0:28: dev error handler
[  299.286277] sas: ata10: end_device-0:0:29: dev error handler
[  299.286282] sas: ata11: end_device-0:0:30: dev error handler
[  299.286287] sas: ata12: end_device-0:0:31: dev error handler
[  299.286291] sas: broadcast received: 0
[  299.286293] sas: broadcast received: 0
[  299.286294] sas: broadcast received: 0
[  299.286296] sas: broadcast received: 0
[  299.286297] sas: broadcast received: 0
[  299.286299] sas: broadcast received: 0
[  299.286300] sas: broadcast received: 0
[  299.286302] sas: REVALIDATION DEFERRED on port 0, pid:294
[  299.286345] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  299.286369] sas: REVALIDATING DOMAIN on port 0, pid:294
[  299.294857] sas: Expander phy change count has changed
[  299.302827] sas: ex 5001b4d50fc8103f phy36 originated BROADCAST(CHANGE)
[  299.303277] sas: ex 5001b4d50fc8103f phy 0x24 broadcast flutter
[  299.303521] sas: done REVALIDATING DOMAIN on port 0, pid:294, res 0x0
[  330.097287] scsi 0:0:8:0: command ffff880263890480 timed out
[  330.097356] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  330.097360] sas: trying to find task 0xffff8802628c2b00
[  330.097362] sas: sas_scsi_find_task: aborting task 0xffff8802628c2b00
[  350.076967] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  350.076973] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  350.076976] sas: sas_scsi_find_task: querying task 0xffff8802628c2b00
[  370.056550] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  370.056555] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  370.056557] sas: sas_scsi_find_task: task 0xffff8802628c2b00 failed to abort
[  370.056560] sas: task 0xffff8802628c2b00 is not at LU: I_T recover
[  370.056562] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  372.055328] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  372.055330] sas: broadcast received: 0
[  372.055336] sas: broadcast received: 0
[  372.055339] sas: broadcast received: 0
[  372.055341] sas: I_T 5001b4d50fc8103d recovered
[  372.055343] sas: broadcast received: 0
[  372.055345] sas: broadcast received: 0
[  372.055346] sas: broadcast received: 0
[  372.055350] sas: ata5: end_device-0:0:0: dev error handler
[  372.055364] sas: broadcast received: 0
[  372.055367] sas: ata6: end_device-0:0:1: dev error handler
[  372.055374] sas: ata7: end_device-0:0:2: dev error handler
[  372.055380] sas: ata8: end_device-0:0:3: dev error handler
[  372.055386] sas: ata9: end_device-0:0:28: dev error handler
[  372.055392] sas: ata10: end_device-0:0:29: dev error handler
[  372.055403] sas: ata11: end_device-0:0:30: dev error handler
[  372.055404] sas: ata12: end_device-0:0:31: dev error handler
[  372.055408] sas: broadcast received: 0
[  372.055411] sas: REVALIDATION DEFERRED on port 0, pid:294
[  372.055427] sas: REVALIDATING DOMAIN on port 0, pid:72
[  372.055430] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  372.063448] sas: Expander phy change count has changed
[  372.070701] sas: ex 5001b4d50fc8103f phy36 originated BROADCAST(CHANGE)
[  372.071058] sas: ex 5001b4d50fc8103f phy 0x24 broadcast flutter
[  372.071240] sas: done REVALIDATING DOMAIN on port 0, pid:72, res 0x0
[  402.866395] scsi 0:0:8:0: command ffff8802614dca80 timed out
[  402.866463] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  402.866467] sas: trying to find task 0xffff88026216fb40
[  402.866469] sas: sas_scsi_find_task: aborting task 0xffff88026216fb40
[  422.846084] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  422.846089] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  422.846091] sas: sas_scsi_find_task: querying task 0xffff88026216fb40
[  442.825625] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  442.825630] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  442.825633] sas: sas_scsi_find_task: task 0xffff88026216fb40 failed to abort
[  442.825635] sas: task 0xffff88026216fb40 is not at LU: I_T recover
[  442.825637] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  444.824421] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  444.824423] sas: broadcast received: 0
[  444.824428] sas: broadcast received: 0
[  444.824431] sas: broadcast received: 0
[  444.824433] sas: I_T 5001b4d50fc8103d recovered
[  444.824435] sas: broadcast received: 0
[  444.824436] sas: broadcast received: 0
[  444.824438] sas: broadcast received: 0
[  444.824439] sas: broadcast received: 0
[  444.824440] sas: broadcast received: 0
[  444.824442] sas: REVALIDATING DOMAIN on port 0, pid:72
[  444.833156] sas: Expander phy change count has changed
[  444.840685] sas: ex 5001b4d50fc8103f phy36 originated BROADCAST(CHANGE)
[  444.841134] sas: ex 5001b4d50fc8103f phy 0x24 broadcast flutter
[  444.841378] sas: done REVALIDATING DOMAIN on port 0, pid:72, res 0x0
[  444.841477] sas: ata5: end_device-0:0:0: dev error handler
[  444.841489] sas: ata6: end_device-0:0:1: dev error handler
[  444.841494] sas: ata7: end_device-0:0:2: dev error handler
[  444.841499] sas: ata8: end_device-0:0:3: dev error handler
[  444.841503] sas: ata9: end_device-0:0:28: dev error handler
[  444.841507] sas: ata10: end_device-0:0:29: dev error handler
[  444.841512] sas: ata11: end_device-0:0:30: dev error handler
[  444.841516] sas: ata12: end_device-0:0:31: dev error handler
[  444.841565] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  475.763182] scsi 0:0:8:0: command ffff8802614dca80 timed out
[  475.763240] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  475.763244] sas: trying to find task 0xffff88026216fb40
[  475.763246] sas: sas_scsi_find_task: aborting task 0xffff88026216fb40
[  495.742855] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[1] timeout.
[  495.742860] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1642:mvs_abort_task:rc= 5
[  495.742863] sas: sas_scsi_find_task: querying task 0xffff88026216fb40
[  515.722399] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1417:TMF task[80] timeout.
[  515.722403] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1564:mvs_query_task:rc= 5
[  515.722406] sas: sas_scsi_find_task: task 0xffff88026216fb40 failed to abort
[  515.722408] sas: task 0xffff88026216fb40 is not at LU: I_T recover
[  515.722410] sas: I_T nexus reset for dev 5001b4d50fc8103d
[  517.721211] /build/buildd-linux_3.5-1~experimental.1-i386-3Zh1AJ/linux-3.5/drivers/scsi/mvsas/mv_sas.c 1522:mvs_I_T_nexus_reset for device[9]:rc= 0
[  517.721213] sas: broadcast received: 0
[  517.721218] sas: broadcast received: 0
[  517.721221] sas: broadcast received: 0
[  517.721223] sas: I_T 5001b4d50fc8103d recovered
[  517.721225] sas: broadcast received: 0
[  517.721226] sas: broadcast received: 0
[  517.721230] sas: ata5: end_device-0:0:0: dev error handler
[  517.721240] sas: broadcast received: 0
[  517.721244] sas: ata6: end_device-0:0:1: dev error handler
[  517.721249] sas: ata7: end_device-0:0:2: dev error handler
[  517.721255] sas: ata8: end_device-0:0:3: dev error handler
[  517.721261] sas: ata9: end_device-0:0:28: dev error handler
[  517.721267] sas: ata10: end_device-0:0:29: dev error handler
[  517.721272] sas: ata11: end_device-0:0:30: dev error handler
[  517.721277] sas: ata12: end_device-0:0:31: dev error handler
[  517.721281] sas: broadcast received: 0
[  517.721284] sas: broadcast received: 0
[  517.721287] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[  517.721289] sas: REVALIDATING DOMAIN on port 0, pid:72
[  517.730375] sas: Expander phy change count has changed
[  517.738403] sas: ex 5001b4d50fc8103f phy36 originated BROADCAST(CHANGE)
[  517.738859] sas: ex 5001b4d50fc8103f phy 0x24 broadcast flutter
[  517.739087] sas: done REVALIDATING DOMAIN on port 0, pid:72, res 0x0


--------------040409090304040405020704--
