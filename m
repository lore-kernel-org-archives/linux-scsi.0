From: Owen Williams <williams@dmu.ac.uk>
Subject: LSI 1068e megasr propreitary driver and options
Date: Tue, 10 Jun 2008 15:26:35 +0100
Message-ID: <1213107996.28779.45.camel@ocean.blue.dmu.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ocean.blue.dmu.ac.uk ([146.227.8.41]:44230 "EHLO
	ocean.blue.dmu.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYFJOsM (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 10:48:12 -0400
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ocean.blue.dmu.ac.uk (8.14.1/8.14.1) with ESMTP id m5AEQal8017970
	for <Linux-scsi@vger.kernel.org>; Tue, 10 Jun 2008 15:26:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Hello,
  I have a SuperMicro 7045A-T with a 4 SAS drives connected to an on
board LSI 1068e.  The only way I have found to install linux to see
these drives is to use either RHEL or SLES and LSI's proprietary mesgasr
driver.  Apparently the driver will only work with 2.6.19 and below.

The driver:

ftp://ftp.supermicro.com/driver/SAS/LSI/Driver/1068/SR/Linux/09.32_RedHat5.zip

Is this still the case?

I see mention of 1068e in fusion drivers mptbase and mptsas but the/my
usual distros don't pick up the drives.  Is it possible that because the
chip is labelled: 'Subsystem: Super Micro Computer Inc Unknown device
a480' that installers can't cope?

Thanks for any help,

Owen.

This is the relevant lspci -vv for the chip:

02:00.0 SCSI storage controller: LSI Logic / Symbios Logic MegaRAID SAS
8208ELP/8208ELP (rev 08)
        Subsystem: Super Micro Computer Inc Unknown device a480
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at 2000 [size=256]
        Region 1: Memory at d3310000 (64-bit, non-prefetchable)
[size=16K]
        Region 3: Memory at d3300000 (64-bit, non-prefetchable)
[size=64K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1,
Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003000
        Capabilities: [100] Advanced Error Reporting <?>

-- 
Owen Williams
williams@dmu.ac.uk


