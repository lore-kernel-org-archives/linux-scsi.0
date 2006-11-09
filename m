From: "Wesley J. Landaker" <wjl@icecavern.net>
Subject: Support for (new?) Silicon Image PCI SATA controller
Date: Wed, 8 Nov 2006 18:03:52 -0700
Message-ID: <200611081803.52986.wjl@icecavern.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c-68-54-3-45.hsd1.nm.comcast.net ([68.54.3.45]:48141 "EHLO
	icecavern.net") by vger.kernel.org with ESMTP id S1423979AbWKIBDu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Nov 2006 20:03:50 -0500
Received: from ubuntu.local (unknown [10.0.0.166])
	by icecavern.net (Postfix) with ESMTP id CBCC9ED912
	for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2006 18:03:47 -0700 (MST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi folks,

I just obtained a new PCI SATA controller card that I was told was supported 
by Linux, but it doesn't appear to match up with the expected device IDs I 
see listed in the sata_sil or sata_sil24 drivers currently.

Does anyone have any knowledge about this device? e.g. is it a new Silicon 
Image device, or perhaps I am mistaken and it's a really *old* one?

Here is the output of lspci -vvnn for the device, which captures as much info 
as I know how to easily obtain. It would be really interested if someone 
could tell me if this looks anything like a possible-to-support SI device, so 
I know whether it's worth pursuing or not?

00:10.0 Mass storage controller [0180]: Silicon Image, Inc. Unknown device 
[1095:2502] (rev 01)
        Subsystem: Silicon Image, Inc. Unknown device [1095:2512]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at d800 [size=8]
        Region 1: I/O ports at dc00 [size=4]
        Region 2: I/O ports at e000 [size=8]
        Region 3: I/O ports at e400 [size=4]
        Region 4: I/O ports at e800 [size=16]
        Region 5: Memory at c1000000 (32-bit, non-prefetchable) [size=512]
        [virtual] Expansion ROM at 13000000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

-- 
Wesley J. Landaker <wjl@icecavern.net>
