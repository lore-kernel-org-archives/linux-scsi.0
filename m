From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Mon, 4 Jul 2011 22:47:17 GMT
Message-ID: <201107042247.p64MlHMc021740@demeter1.kernel.org>
References: <bug-14534-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59441 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1GDWrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 18:47:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p64MlHpl021742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 4 Jul 2011 22:47:17 GMT
In-Reply-To: <bug-14534-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #12 from Stonefish <iamthestonefishdammit@hotmail.com>  2011-07-04 22:47:15 ---
Created an attachment (id=64642)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=64642)
/var/log/messages

That's the entire output of /var/log/messages from the time it fails.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
