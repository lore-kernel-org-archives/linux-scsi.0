From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35282] BUG() in 2.6.38.6
Date: Sat, 28 May 2011 16:57:03 GMT
Message-ID: <201105281657.p4SGv3UR028429@demeter1.kernel.org>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50937 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1E1Q5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 May 2011 12:57:05 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4SGv3pL028430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 28 May 2011 16:57:03 GMT
In-Reply-To: <bug-35282-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35282





--- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2011-05-28 16:57:01 ---
Reply-To: James.Bottomley@HansenPartnership.com

> --- Comment #5 from Nils Kneuper <crazy-ivanovic@gmx.net>  2011-05-27 09:53:06 ---
> I had some crashes over here, especially with 2.6.39, but also with some
> 2.6.38.*, kernel versions, too. Applied this patch about 24h ago and so far
> there seem to be no further kernel panics. Since I know no way to actually get
> the logs from the crashes, I just photographed them using my mobile phone:
> http://imagebin.org/index.php?mode=image&id=155275
> http://imagebin.org/index.php?mode=image&id=155274

That looks like this:

http://marc.info/?l=linux-scsi&m=130635674521428

It depends on a couple of other block fixes, though.  Everything will
probably be upstream and back to stable in the next few days.

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
