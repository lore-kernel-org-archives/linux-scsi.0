From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10979] INFO: possible recursive locking detected
Date: Wed, 25 Jun 2008 08:39:01 -0700 (PDT)
Message-ID: <20080625153901.63576108045@picon.linux-foundation.org>
References: <bug-10979-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbYFYPjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 11:39:33 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5PFd1np005246
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 08:39:02 -0700
In-Reply-To: <bug-10979-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10979


akpm@osdl.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@osdl.org,
                   |                            |axboe@kernel.dk




------- Comment #1 from akpm@osdl.org  2008-06-25 08:39 -------
hrm, I'm not sure why that didn't simply deadlock.  But still, doing
blk_sync_queue()
within the context of __generic_unplug_device(), with the queue lock
held sounds wrong.

Jens, could you please have a ponder?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
