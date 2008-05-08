From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Thu,  8 May 2008 12:06:31 -0700 (PDT)
Message-ID: <20080508190631.45CD9108094@picon.linux-foundation.org>
References: <bug-10622-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932411AbYEHTHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 15:07:31 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m48J70iS010423
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 12:07:02 -0700
In-Reply-To: <bug-10622-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10622


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dan.j.williams@gmail.com




------- Comment #1 from rjw@sisk.pl  2008-05-08 12:06 -------
Regressions list annotation:
Handled-By : Dan Williams <dan.j.williams@intel.com>
Patch : http://marc.info/?l=linux-raid&m=121001065404056&w=2


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
