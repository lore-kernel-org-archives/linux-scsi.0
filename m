From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Thu, 23 Jul 2009 07:58:18 GMT
Message-ID: <200907230758.n6N7wI20031999@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40197 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZGWH6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2009 03:58:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6N7wIpZ032000
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2009 07:58:18 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #11 from Andreas Fackler <AndreasFackler@web.de>  2009-07-23 07:58:16 ---
lspci -v and lshw say the SATA controller uses the ahci driver. They don't list
any drivers or modules belonging to the optical drive, and it seems to be the
same in the files Christian Mallwitz posted.
My blacklist files are just the Ubuntu defaults.
Here is what dmesg says:

[    1.500033] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.513385] ata2.00: ATAPI: Optiarc DVD RW AD-7560S, SX07, max UDMA/100,
ATAPI AN
[    1.527733] ata2.00: configured for UDMA/100
[    1.545118] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7560S  SX07
PQ: 0 ANSI: 5
[    1.550572] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda
tray
[    1.550575] Uniform CD-ROM driver Revision: 3.20
[    1.550642] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.550691] sr 1:0:0:0: Attached scsi generic sg1 type 5

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
