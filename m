From: Thomas Steudten <alpha@steudten.com>
Subject: Msg from scsi aic7xxx driver or PCI layer on alpha
Date: Thu, 11 Mar 2004 22:56:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4050E09D.8040907@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 217-162-71-11.dclient.hispeed.ch ([217.162.71.11]:48000 "EHLO
	steudten.com") by vger.kernel.org with ESMTP id S261764AbUCKV4r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 16:56:47 -0500
Received: from steudten.com (excalibur.linux.alpha [192.168.1.8])
	(authenticated bits=0)
	by steudten.com (8.12.11/8.12.11) with ESMTP id i2BLujgM012960
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2004 22:56:45 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

I got this messages from the pci allocator and the
scsi aic7xxx driver on kernel 2.6.4 on alpha after
reboot: (why is this driver don=B4t using dma?)

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
         <Adaptec 2940 Ultra SCSI adapter>
         aic7880: Ultra Wide Channel A, SCSI Id=3D7, 16/253 SCBs

[..]
scsi0:A:3:0: Tagged Queuing enabled.  Depth 128
PCI: Enabling device: (0000:00:07.0), cmd 7
XXX PCI: Unable to reserve mem region #2:1000@a051000 for device 0000:0=
0:07.0
aic7xxx: <Adaptec AHA-294X Ultra SCSI host adapter> at PCI 0/7/0
XXX aic7xxx: I/O ports already in use, ignoring.

lspci -vv gives
00:07.0 SCSI storage controller: Adaptec AHA-2940U/UW/D / AIC-7881U (re=
v 01)
         Subsystem: Adaptec AHA-2940UW SCSI Host Adapter
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-=20
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAb=
ort-=20
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (2000ns min, 2000ns max), cache line size 08
         Interrupt: pin A routed to IRQ 26
         Region 0: I/O ports at 8400 [size=3D256]
         Region 1: Memory at 000000000a051000 (32-bit, non-prefetchable=
)=20
[size=3D4K]
         Expansion ROM at 000000000a040000 [disabled] [size=3D64K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-



--=20
Tom

LINUX user since kernel 0.99.x 1994.
RPM Alpha packages at http://alpha.steudten.com/packages
Want to know what S.u.S.E 1995 cdrom-set contains?



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
