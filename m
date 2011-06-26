From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36702] 2.6.39 kernel panic w/screenshots & kernel cfg link
 provided
Date: Sun, 26 Jun 2011 23:01:19 GMT
Message-ID: <201106262301.p5QN1JpL022168@demeter1.kernel.org>
References: <bug-36702-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45202 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1FZXBU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jun 2011 19:01:20 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5QN1Jg2022169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jun 2011 23:01:19 GMT
In-Reply-To: <bug-36702-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=36702





--- Comment #1 from Justin Piszcz <jpiszcz@lucidpixels.com>  2011-06-26 23:01:16 ---
Hi,

After disconnecting the USB devices as mentioned earlier in the thread (floppy,
2 CDROM drives, flash readers in monitors, etc), the system has not crashed
again (yet), I'll get it some more time, but I am guessing that is what it was
as there have been no recent crashes, also I am running 2.6.39.2 now.

Linux p34 2.6.39.2 #1 SMP Thu Jun 23 18:46:30 EDT 2011 x86_64 GNU/Linux

If I do not update this in the next few days/weeks it can be resolved and the
root cause is most likely those USB devices (I hope, which are disconnected
now).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
