From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Thu, 14 Jul 2011 10:41:04 GMT
Message-ID: <201107141041.p6EAf4E2001094@demeter1.kernel.org>
References: <bug-14534-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37203 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1GNKlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2011 06:41:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6EAf4LZ001095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2011 10:41:04 GMT
In-Reply-To: <bug-14534-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #15 from taeuber@bbaw.de  2011-07-14 10:40:58 ---
Hi,

I've tested the newsest 3.0-rc7 version and still get the errors.
I'll attach the dmesg output.

The crash was provoked with:

# dd if=/dev/zero of=/dev/sdc

* ARECA ARC1300 SAS HBA with latest firmware
* Hitachi Ultrastar 7k3000 SATA disks
* 64 bit kernel
* mvsas driver

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
