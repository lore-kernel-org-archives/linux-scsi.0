From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Thu, 22 Jul 2010 08:22:24 GMT
Message-ID: <201007220822.o6M8MOwW015562@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57192 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0GVIW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 04:22:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6M8MOuq015563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2010 08:22:25 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #16 from Neil Brown <neilb@suse.de>  2010-07-22 07:41:04 ---
It looks like the problem is commit 74450be123b6f3cb480c358a056be398cce6aa6e

This was recently reported on linux-kernel (and other mailing lists).

It is probable that the 'bool' variables (do_sync and do_barrier) in
drivers/md/raid1.c need to be changed to 'unsigned long'. 
Can you please test that and report?

Thanks,
NeilBrown

--- Comment #17 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-22 08:22:17 ---
You mean reverting this commit 74450be123b6f3cb480c358a056be398cce6aa6e

Thanks
Pawel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
