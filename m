From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Fri,  9 May 2008 05:43:59 -0700 (PDT)
Message-ID: <20080509124359.1033F10805F@picon.linux-foundation.org>
References: <bug-10622-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764613AbYEIMoa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 08:44:30 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m49ChxZE012234
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2008 05:44:00 -0700
In-Reply-To: <bug-10622-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10622





------- Comment #3 from rjw@sisk.pl  2008-05-09 05:43 -------
Regressions list annotation:
Ignore-Patch : http://marc.info/?l=linux-raid&m=121001065404056&w=2


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
