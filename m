From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10979] INFO: possible recursive locking detected
Date: Wed, 25 Jun 2008 12:15:45 -0700 (PDT)
Message-ID: <20080625191545.B3795108047@picon.linux-foundation.org>
References: <bug-10979-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbYFYTQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 15:16:18 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5PJFjPx022260
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 12:15:46 -0700
In-Reply-To: <bug-10979-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10979





------- Comment #3 from akpm@osdl.org  2008-06-25 12:15 -------
I think we do and I expect it's accidental - vie two nested
kobject_put()s.

If the backtrace is indeed incorrect then please let us know and
we can bug people about it.  I thought that the non-question-marked
entries are considered reliable.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
