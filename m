From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 10:25:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404131025.43474.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HQ6eAOQiKU3SEGb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:27342 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S262972AbUDMIZg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 04:25:36 -0400
Received: from mail.wim-media.de (localhost.localdomain [127.0.0.1])
	by wim-media.de (Postfix) with ESMTP id A87B2398002
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2004 10:26:11 +0200 (CEST)
Received: from [192.168.1.3] (pD95498A4.dip.t-dialin.net [217.84.152.164])
	by mail.wim-media.de (Postfix) with ESMTP id E3EBE398001
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2004 10:26:05 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Boundary-00=_HQ6eAOQiKU3SEGb
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Some compiler messages:

drivers/scsi/tmscsim.c: In function `dc390_pci_map':
drivers/scsi/tmscsim.c:1028: warning: unsigned int format, different type arg
(arg 4)
drivers/scsi/tmscsim.c:1049: warning: unsigned int format, different type arg
(arg 4)
drivers/scsi/tmscsim.c: In function `dc390_pci_unmap':
drivers/scsi/tmscsim.c:1066: warning: unsigned int format, different type arg
(arg 3)
drivers/scsi/tmscsim.c:1076: warning: unsigned int format, different type arg
(arg 3)

> kern.*                          -/var/log/tmscsim.log

I use metalong and I have not spent time looking for the configuration. I
thin /var/log/everthing/current should also contain kern.*

cat /proc/scsi/scsi:

Host: scsi4 Channel: 00 Id: 04 Lun: 00
  Vendor: d-linux- Model: x86-64.so.2      Rev: prea
  Type:   Direct-Access                    ANSI SCSI revision: ffffffff


lspci -vvxxx:

0000:00:00.0 Host bridge: nVidia Corporation nForce3 Host Bridge (rev a4)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at e0000000 (32-bit, prefetchable)
        Capabilities: [44] #08 [0180]
        Capabilities: [c0] AGP version 3.0
                Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3+ Rate=x4,x8
                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW+
Rate=x8
00: de 10 d1 00 06 01 b0 00 a4 00 00 06 00 00 00 00
10: 08 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00
40: 00 00 00 00 08 c0 80 01 22 00 01 01 d0 00 00 00
50: 23 04 1f 00 03 00 00 00 00 00 00 00 00 00 00 00
60: 32 31 03 00 66 45 04 00 66 06 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 30 30 00 00 13 66 66 00
80: 13 66 66 00 c8 00 00 00 70 00 00 00 1f 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 02 00 30 00 1b 42 00 1f 12 03 00 00 ff ff ff ff
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:01.0 ISA bridge: nVidia Corporation nForce3 LPC Bridge (rev a6)
        Subsystem: Giga-byte Technology: Unknown device 0c11
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
00: de 10 d0 00 0f 00 a0 00 a6 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 7f b1 29 04 00 00 00 01 00 00 ff ff
60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
70: 10 00 ff ff 03 00 00 00 00 00 40 00 97 bb 07 00
80: 09 b7 00 00 bb 00 09 00 3f 00 00 00 00 00 00 00
90: 00 00 33 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 10 00 00 00 00 00 00 80 24 40 20 71 33 14 00
f0: 00 ff 5f bf 00 00 00 00 10 ff ff ff 00 00 30 07

0000:00:01.1 SMBus: nVidia Corporation nForce3 SMBus (rev a4)
        Subsystem: Giga-byte Technology: Unknown device 0c11
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 7
        Region 4: I/O ports at 1c00 [size=64]
        Region 5: I/O ports at 2000 [size=64]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 d4 00 01 00 b0 00 a4 00 05 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 1c 00 00 01 20 00 00 00 00 00 00 58 14 11 0c
30: 00 00 00 00 44 00 00 00 00 00 00 00 07 01 03 01
40: 58 14 11 0c 01 00 02 c0 00 00 00 00 00 00 00 00
50: 01 1c 00 00 01 20 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:02.0 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
(prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f5002000 (32-bit, non-prefetchable)
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 d7 00 07 00 b0 00 a5 10 03 0c 00 00 80 00
10: 00 20 00 f5 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 04 50
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 03 01
40: 58 14 04 50 01 00 02 fe 00 00 00 00 02 00 00 00
50: 00 00 00 00 1d 47 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 ff ff ff 04 09 30 07

0000:00:02.1 USB Controller: nVidia Corporation nForce3 USB 1.1 (rev a5)
(prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at f5003000 (32-bit, non-prefetchable)
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 d7 00 07 00 b0 00 a5 10 03 0c 00 00 80 00
10: 00 30 00 f5 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 04 50
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 02 03 01
40: 58 14 04 50 01 00 02 fe 00 00 00 00 03 00 00 00
50: 0c 00 00 00 1d 47 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 ff ff ff 04 0c 30 07

0000:00:02.2 USB Controller: nVidia Corporation nForce3 USB 2.0 (rev a2)
(prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin C routed to IRQ 11
        Region 0: Memory at f5004000 (32-bit, non-prefetchable)
        Capabilities: [44] #0a [2080]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 d8 00 06 00 b0 00 a2 20 03 0c 00 00 80 00
10: 00 40 00 f5 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 04 50
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 03 03 01
40: 58 14 04 50 0a 80 80 20 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 20 20 01 00 00 60 98 81 c3 13 00 00 00 00 00 00
70: 00 00 00 05 00 10 30 80 89 3d 84 22 77 25 04 80
80: 01 00 02 fe 00 00 00 00 00 00 00 00 15 16 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 00 00 00 00 0c e0 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 ff ff ff 00 00 30 07

0000:00:06.0 Multimedia audio controller: nVidia Corporation nForce3 Audio
(rev a2)
        Subsystem: Giga-byte Technology: Unknown device a002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (500ns min, 1250ns max)
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at d800
        Region 1: I/O ports at dc00 [size=128]
        Region 2: Memory at f5000000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 da 00 07 00 b0 00 a2 00 01 04 00 00 00 00
10: 01 d8 00 00 01 dc 00 00 00 00 00 f5 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 02 a0
30: 00 00 00 00 44 00 00 00 00 00 00 00 09 01 02 05
40: 58 14 02 a0 01 00 02 06 00 00 00 00 06 01 00 01
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 10 ff ff ff 04 06 30 07

0000:00:08.0 IDE interface: nVidia Corporation nForce3 IDE (rev a5) (prog-if
8a [Master SecP PriP])
        Subsystem: Giga-byte Technology: Unknown device 5002
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 4: I/O ports at f000 [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: de 10 d5 00 05 00 b0 00 a5 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 f0 00 00 00 00 00 00 00 00 00 00 58 14 02 50
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01
40: 58 14 02 50 01 00 02 00 00 00 00 00 00 09 00 00
50: 03 f0 00 00 00 00 00 00 77 20 20 20 01 00 22 20
60: 03 c4 c7 c7 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 bd 11 00 00 1a 08 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 12 ff ff ff 05 11 30 07

0000:00:0a.0 PCI bridge: nVidia Corporation nForce3 PCI Bridge (rev a2)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=128
        I/O behind bridge: 00009000-0000cfff
        Memory behind bridge: f3000000-f4ffffff
        Prefetchable memory behind bridge: f0000000-f0ffffff
        Expansion ROM at 00009000 [disabled] [size=16K]
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
00: de 10 dd 00 07 01 a0 00 a2 00 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 80 90 c0 80 a2
20: 00 f3 f0 f4 00 f0 f0 f0 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00
40: 00 00 03 00 01 00 02 00 01 00 00 00 00 00 44 00
50: 00 00 fe 1f 00 00 00 00 ef 1f 00 00 03 00 80 00
60: 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:0b.0 PCI bridge: nVidia Corporation nForce3 AGP Bridge (rev a4)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 16
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=10
        Memory behind bridge: f1000000-f2ffffff
        Prefetchable memory behind bridge: e8000000-efffffff
        BridgeCtl: Parity+ SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
00: de 10 d2 00 07 01 20 02 a4 00 04 06 00 10 01 00
10: 00 00 00 00 00 00 00 00 00 02 02 0a f0 00 20 22
20: 00 f1 f0 f2 00 e8 f0 ef 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0f 00
40: 01 00 00 00 00 00 f0 1f 20 00 00 00 00 00 00 00
50: 00 00 00 e0 00 f0 ff e7 ff ff ff ff ff ff ff ff
60: ff 40 ff 40 00 00 00 20 00 00 00 20 ff ff ff ff
70: ff ff ff ff 00 00 00 00 00 00 00 00 ff ff ff ff
80: ff ff ff ff 00 80 00 00 cd 01 00 00 ff ff ff ff
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
a0: 1b 42 00 1f 00 00 00 00 0c 00 00 00 00 00 00 00
b0: 04 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 20 00 00 80 82 ff 32 07 00 05 30 07
d0: 00 00 00 00 00 00 00 00 08 00 00 e0 ff ff ff e7
e0: b0 b5 f7 ef b0 7f bf bf 70 d5 7e df f0 fe ef fb
f0: b0 de 57 ff f0 f7 ef af d0 3a ed ff 70 f5 f7 ef

0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [80] #08 [2101]
00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
40: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
60: 00 00 00 00 e4 00 00 00 0f cc 00 0f 0c 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 08 00 01 21 20 00 11 10 22 04 75 80 02 00 00 00
90: 56 04 51 02 00 00 ff 00 07 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 03 00 00 00 00 00 1f 00 00 00 20 00 01 00 00 00
50: 00 00 20 00 02 00 00 00 00 00 20 00 03 00 00 00
60: 00 00 20 00 04 00 00 00 00 00 20 00 05 00 00 00
70: 00 00 20 00 06 00 00 00 00 00 20 00 07 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 03 0a 00 00 00 0b 00 00 03 00 20 00 00 70 ff 00
c0: 00 00 00 00 00 00 00 00 13 10 00 00 00 f0 0f 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 03 00 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 00 00 00 01 00 00 01 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 fe e0 00 00 fe e0 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 03 00 00 00 00 00 00 00 45 34 83 13 31 0b 00 00
90: 00 8c 0c 08 07 07 7b 06 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 92 18 7c b2 9a 00 00 00 7b f5 01 21 2c 3f c6 d1
c0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 04 bc c1 a7 6c 20 dd f8 c9 30 49 ec 2f 98 b9 a5
e0: 2f bf f9 2f 29 68 d5 b6 5a bd 60 16 31 66 49 78
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: ff 3b 00 00 40 00 00 00 00 00 00 00 00 00 00 00
50: 60 20 e2 bc f1 00 00 00 00 00 00 00 00 09 00 08
60: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 11 01 02 51 11 80 00 50 00 38 00 08 1b 22 00 00
80: 00 00 07 23 13 21 13 21 00 00 00 00 00 00 00 00
90: 05 00 00 00 70 00 00 00 00 c0 1f 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 07 07 e2 04 00 00 00 00 00 00 00 00
e0: 00 00 00 00 20 0e 57 00 08 01 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 9000
        Region 1: Memory at f4004000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: ec 10 39 81 07 00 90 02 10 00 00 02 00 20 00 00
10: 01 90 00 00 00 40 00 f4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ec 10 39 81
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 20 40
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 f7 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:07.0 SCSI storage controller: Advanced Micro Devices [AMD] 53c974
[PCscsi] (rev 10)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping+ SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 9400
00: 22 10 20 20 c5 01 00 02 10 00 00 01 00 20 00 00
10: 01 94 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 04 28
40: 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:09.0 Multimedia video controller: Brooktree Corporation Bt848 Video
Capture (rev 12)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at f0000000 (32-bit, prefetchable)
00: 9e 10 50 03 06 00 80 02 12 00 00 04 00 20 00 00
10: 08 00 00 f0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 01 10 28
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:0a.0 Network controller: AVM Audiovisuelles MKTG & Computer System
GmbH B1 ISDN
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 9800
        Region 1: I/O ports at 9c00 [size=32]
00: 44 12 00 07 07 00 00 00 00 00 80 02 00 20 00 00
10: 01 98 00 00 01 9c 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

0000:01:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
(rev 10)
        Subsystem: Giga-byte Technology: Unknown device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min, 16000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at a000
        Region 1: Memory at f4007000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: ec 10 69 81 07 00 b0 02 10 00 00 02 08 20 00 00
10: 01 a0 00 00 00 70 00 f4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 00 e0
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 20 40
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 c2 f7
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:0c.0 RAID bus controller: Integrated Technology Express, Inc.:
 Unknown device 8212 (rev 11)
        Subsystem: Integrated Technology Express, Inc.: Unknown device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (2000ns min, 2000ns max)
        Interrupt: pin A routed to IRQ 7
        Region 0: I/O ports at a410
        Region 1: I/O ports at a800 [size=4]
        Region 2: I/O ports at ac10 [size=8]
        Region 3: I/O ports at b000 [size=4]
        Region 4: I/O ports at b400 [size=16]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 83 12 12 82 07 00 30 02 11 00 04 01 00 00 00 00
10: 11 a4 00 00 01 a8 00 00 11 ac 00 00 01 b0 00 00
20: 01 b4 00 00 00 00 00 00 00 00 00 00 83 12 01 00
30: 00 00 00 00 80 00 00 00 00 00 00 00 07 01 08 08
40: 00 a0 36 00 08 00 08 00 02 02 00 00 04 02 04 02
50: 01 20 00 00 a3 00 31 31 a3 00 31 31 00 1a 02 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:0d.0 RAID bus controller: CMD Technology Inc: Unknown device 3512
 (rev 01)
        Subsystem: CMD Technology Inc: Unknown device 6512
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, cache line size 08
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at b800
        Region 1: I/O ports at bc00 [size=4]
        Region 2: I/O ports at c000 [size=8]
        Region 3: I/O ports at c400 [size=4]
        Region 4: I/O ports at c800 [size=16]
        Region 5: Memory at f4005000 (32-bit, non-prefetchable) [size=512]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
00: 95 10 12 35 07 00 b0 02 01 00 04 01 08 20 00 00
10: 01 b8 00 00 01 bc 00 00 01 c0 00 00 01 c4 00 00
20: 01 c8 00 00 00 50 00 f4 00 00 00 00 95 10 12 65
30: 00 00 00 00 60 00 00 00 00 00 00 00 09 01 00 00
40: 02 00 00 00 02 a0 22 80 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 01 00 22 06 00 40 00 64 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 22 00 00 00 22 00 00 00 00 00 00 00 ff ff ef a4
90: 00 00 00 08 ff ff 00 00 00 00 00 18 00 00 00 00
a0: 01 21 15 65 dd 62 dd 62 92 43 92 43 09 40 09 40
b0: 01 21 15 65 dd 62 dd 62 92 43 92 43 09 40 09 40
c0: 84 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

0000:01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: Giga-byte Technology: Unknown device 1000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 1000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f4006000 (32-bit, non-prefetchable)
        Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 4c 10 24 80 06 00 10 02 00 10 00 0c 08 20 00 00
10: 00 60 00 f4 00 00 00 f4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 00 10
30: 00 00 00 00 44 00 00 00 00 00 00 00 0b 01 02 04
40: 00 00 00 00 01 00 02 7e 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 88 00 00 00
f0: 10 00 00 00 82 10 00 00 58 14 00 10 00 00 00 00

0000:02:00.0 VGA compatible controller: nVidia Corporation NV18 [GeForce4 MX
440 AGP 8x] (rev a2) (prog-if 00 [VGA])
        Subsystem: Asustek Computer, Inc.: Unknown device 8063
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 248 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 7
        Region 0: Memory at f1000000 (32-bit, non-prefetchable)
        Region 1: Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 3.0
                Status: RQ=32 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3+ Rate=x4,x8
                Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- FW+
Rate=x8
00: de 10 81 01 07 00 b0 02 a2 00 00 03 00 f8 00 00
10: 00 00 00 f1 08 00 00 e8 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 63 80
30: 00 00 00 00 60 00 00 00 00 00 00 00 07 01 05 01
40: 43 10 63 80 02 00 30 00 1b 0e 00 1f 12 43 00 1f
50: 01 00 00 00 01 00 00 00 ce d6 23 00 0f 00 00 00
60: 01 44 02 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


Regards

Christian

-------------------------------------------------------



-- 
Roessner Network Solutions (R.N.S.)

Tel.: 0641-2097252, Fax: 0641-2097253, Mobil: 0171-3611230
URL: http://www.roessner-net.com/
PGP: http://www.roessner-nat.com/kontakt/0x6A549505.asc


--Boundary-00=_HQ6eAOQiKU3SEGb
Content-Type: text/plain;
  charset="iso-8859-15";
  name="current_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="current_debug"

Apr 13 10:16:32 [kernel] DC390_init: No EEPROM found! Trying default settings ...
Apr 13 10:16:32 [kernel] DC390: Used defaults: AdaptID=7, SpeedIdx=1 (8.0 MHz), DevMode=0x1f, AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
Apr 13 10:16:32 [kernel] DC390: 1 adapters found
Apr 13 10:16:32 [kernel] scsi4 : Tekram DC390/AM53C974 V2.0f 2000-12-20
Apr 13 10:16:33 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:33 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:33 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:34 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:34 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:34 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:34 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_map(): Mapped sense buffer 000001001e6ab6d8 at 1e6ab6d8
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:34 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523dc0 at 523dc0
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:34 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523dc0
Apr 13 10:16:34 [kernel] DC390: RESET ... done
Apr 13 10:16:37 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_map(): Mapped sense buffer 000001001e6ab6d8 at 1e6ab6d8
Apr 13 10:16:37 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:37 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_map(): Mapped sense buffer 000001001e6ab6d8 at 1e6ab6d8
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:37 [kernel] sda: Unit Not Ready, sense:
Apr 13 10:16:37 [kernel] : sense =  0  0
Apr 13 10:16:37 [kernel] Non-extended sense class 0 code 0x0
Apr 13 10:16:37 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522e00 at 522e00
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:37 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:38 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522e00 at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:38 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522e00 at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e6ab6d8
Apr 13 10:16:38 [kernel] sda : READ CAPACITY failed.
Apr 13 10:16:38 [kernel] sd: sense =  0  0
Apr 13 10:16:38 [kernel] Non-extended sense class 0 code 0x0
Apr 13 10:16:38 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522e00 at 522e00
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 10:16:38 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 522e00
Apr 13 10:16:38 [kernel] sda: asking for cache data failed
Apr 13 10:16:38 [kernel] sda: assuming drive cache: write through
Apr 13 10:16:38 [kernel] Attached scsi disk sda at scsi4, channel 0, id 4, lun 0
Apr 13 10:16:38 [kernel] Attached scsi generic sg1 at scsi4, channel 0, id 4, lun 0,  type 0
Apr 13 10:16:38 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:39 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:39 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523ec0 at 523ec0
Apr 13 10:16:39 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at 523ec0
Apr 13 10:16:39 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated twice -
Apr 13 10:16:39 [scsi.agent] disk at /devices/pci0000:00/0000:00:0a.0/0000:01:07.0/host4/4:0:4:0
Apr 13 10:16:40 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 154 times -
Apr 13 10:17:00 [CRON] (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )_
Apr 13 10:17:00 [kernel] DC390: Irq (11) caught: .. IRQ returned

--Boundary-00=_HQ6eAOQiKU3SEGb--
