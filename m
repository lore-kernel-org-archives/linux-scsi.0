From: "Bhanu, Yogesh" <yogesh@gsf.de>
Subject: gdth problem on 2.6.13
Date: Sun, 11 Sep 2005 15:00:55 +0200
Message-ID: <8306780C060A7D4790F8BA02CBA1B6910A94A3@sw-rz010.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:34229 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S1750700AbVIKNBG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 09:01:06 -0400
Received: from sw-rz010.gsf.de (sw-rz010.gsf.de [146.107.8.106])
	by mta2.gsf.de (Postfix) with ESMTP id 6931A1466A6
	for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2005 15:00:55 +0200 (CEST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi ,
       looks like I probably a bug in gdth driver .
On my system Dual 2.4 Ghz Xeon with Inetl 7501WV2 and intel SRCZR contoller (RAID 1) /w 6 GB RAM
I get the following message when system is booting up on 2.6.13 
 
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
GDT-HA: Storage RAID Controller Driver. Version: 3.04
ACPI: PCI Interrupt 0000:04:08.0[A] -> GSI 48 (level, low) -> IRQ 16
GDT-HA: Found 1 PCI Storage RAID Controllers
Configuring GDT-PCI HA at 4/8 IRQ 16
GDT-HA 0: Name: SRCZCR
scsi0 : SRCZCR
  Vendor: Intel     Model: Host Drive  #00   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: ESG-SHV   Model: SCA HSBP M22      Rev: 0.06
  Type:   Processor                          ANSI SCSI revision: 02
SCSI device sda: 71698095 512-byte hdwr sectors (36709 MB)
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 71698095 512-byte hdwr sectors (36709 MB)
sda: got wrong page
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >

 
 
lspci -vvvv
0000:04:08.0 RAID bus controller: Intel Corp. RAID Controller
        Subsystem: Intel Corp.: Unknown device 01af
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 0x10 (64 bytes)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fa000000 (32-bit, prefetchable) [size=32M]
        Expansion ROM at f8300000 [disabled] [size=32K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Is there a fix in 2.6.13.1 
 
Cheers
yogesh
