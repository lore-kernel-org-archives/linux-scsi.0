From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Sat, 14 Nov 2009 05:01:45 GMT
Message-ID: <200911140501.nAE51jXo005635@demeter.kernel.org>
References: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38904 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZKNFBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2009 00:01:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAE51ji5005636
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2009 05:01:45 GMT
In-Reply-To: <bug-14534-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #9 from quig48pak6ui <arno@wagner.name>  2009-11-14 05:01:40 ---
Just found the patches in the SCSI mailing list archives at 
http://marc.info. I am in the process of trying them out 
on a 4 disk RAID6 setup.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
