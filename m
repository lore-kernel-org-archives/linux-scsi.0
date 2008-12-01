From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12119] iscsi repeatedly times out
Date: Mon,  1 Dec 2008 05:39:49 -0800 (PST)
Message-ID: <20081201133958.2C4EA10800D@picon.linux-foundation.org>
References: <bug-12119-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYLANke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 08:40:34 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB1Ddxra017990
	for <linux-scsi@vger.kernel.org>; Mon, 1 Dec 2008 05:40:00 -0800
In-Reply-To: <bug-12119-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12119





------- Comment #3 from ian@beware.dropbear.id.au  2008-12-01 05:39 -------
Thanks. The patch wouldn't apply but I applied it by hand. It works fine.

I didn't know about the CONFIG_SYSFS_DEPRECIATED options. Unfortunately I can't
upgrade to FC9 or FC10 because of a kernel nfs bug(s) [11061,11154]. I'm not
sure if I could run FC10 with an older kernel, but things like the changes to
sysfs shows it is best not to assume so!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
