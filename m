From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 12 Jan 2010 23:15:41 GMT
Message-ID: <201001122315.o0CNFfNA030971@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35233 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0ALXPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2010 18:15:42 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0CNFfsW030972
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2010 23:15:41 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831


Aaron Williams <aaron.w2@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aaron.w2@gmail.com




--- Comment #9 from Aaron Williams <aaron.w2@gmail.com>  2010-01-12 23:15:37 ---
I am seeing similar events with my current computer and with my last computer.
My setup consists of two WD Black Edition 1TB drives:

Model=WDC WD1001FALS-00J7B0, FwRev=05.00K05, SerialNo=WD-WMATV0705568
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs FmtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=50
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=off
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=1953525168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI
Controller

I also have smartmond running to periodically query the drive. In my case I
have two drives running in a mirrored configuration and this will arbitrarily
kick one of the drives out of my RAID array (using md). I just spent the last
few days recovering from a RAID event that killed the entire array (due to this
problem I believe).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
