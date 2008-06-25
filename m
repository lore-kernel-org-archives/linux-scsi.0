From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10979] INFO: possible recursive locking detected
Date: Wed, 25 Jun 2008 11:27:04 -0700 (PDT)
Message-ID: <20080625182704.82F17108047@picon.linux-foundation.org>
References: <bug-10979-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYFYS1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 14:27:36 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5PIR4WQ018663
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 11:27:05 -0700
In-Reply-To: <bug-10979-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10979





------- Comment #2 from axboe@kernel.dk  2008-06-25 11:27 -------
Andrew, I don't think that is what is going wrong (we are not doing
blk_sync_queue() from __generic_unplug_device(), it's post poned to user
context). So it looks like a "simple" look inversion problem. I'll take a look.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
