From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14653] sysfs: cannot create duplicate filename
 '/bus/scsi/drivers/sd/2:0:1:0'
Date: Sat, 21 Nov 2009 13:17:39 GMT
Message-ID: <200911211317.nALDHdWQ029186@demeter.kernel.org>
References: <bug-14653-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36797 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZKUNRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2009 08:17:33 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nALDHdH4029187
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2009 13:17:39 GMT
In-Reply-To: <bug-14653-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14653





--- Comment #1 from Krzysztof Oledzki <olel@ans.pl>  2009-11-21 13:17:39 ---
scsi2 : qla2xxx
qla2xxx 0000:0c:00.1: LOOP UP detected (4 Gbps).
scsi 2:0:0:0: Direct-Access     DGC      RAID 5           0326 PQ: 0 ANSI: 4
scsi 2:0:0:0: emc: detected Clariion CX3-20c, flags 0
scsi 2:0:0:0: emc: connected to SP A Port 5 (owned, default SP A)
scsi 2:0:1:0: Direct-Access     DGC      RAID 5           0326 PQ: 0 ANSI: 4
scsi 2:0:1:0: emc: detected Clariion CX3-20c, flags 0
qla2xxx 0000:0c:00.1:
 QLogic Fibre Channel HBA Driver: 8.03.01-k4
  QLogic QLE2462 - PCI-Express Dual Channel 4Gb Fibre Channel HBA
  ISP2432: PCIe (2.5GT/s x4) @ 0000:0c:00.1 hdma+, host#=2, fw=4.04.00 (482)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
