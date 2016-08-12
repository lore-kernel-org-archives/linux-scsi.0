From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Fri, 12 Aug 2016 05:42:22 +0000
Message-ID: <bug-151661-11613-ndEO8WtLVx@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41406 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbcHLFnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2016 01:43:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 42FED201ED
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 05:42:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0DBE620268
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 05:42:23 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

Chris "SKip" Mac-Stoker <chrismac@niksun.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chrismac@niksun.com

--- Comment #4 from Chris "SKip" Mac-Stoker <chrismac@niksun.com> ---

.. just created an account and wanted to post a confirmation of this bug, on a
chassis with this controller, the "AAC: Host Adapter Dead -1" did not appear at
all on an Ubuntu 14.04.1 installation (OS installed, not Live USB), but
suddenly showed up after a fresh installation of 16.04 (amd64) on the same
chassis and persists just like the OP says, every 10s. Otherwise the controller
works normally with a RAID5 4-disk array with no noticeable performance
degradation as tested with hdparm -T.

Copying here the relevant lspci -vv stub in case it helps:

---(cut here)---

02:0e.0 RAID bus controller: Adaptec AAC-RAID
        Subsystem: Adaptec 3805
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping+ SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (250ns min, 250ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at e8000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=4
                Status: Dev=02:0e.0 64bit+ 133MHz+ SCD- USC- DC=bridge
DMMRBC=1024 DMOST=4 DMCRS=16 RSCEM- 266MHz- 533MHz-
        Kernel driver in use: aacraid
        Kernel modules: aacraid

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
