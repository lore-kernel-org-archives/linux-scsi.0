From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10725] USB Mass storage mount fails: Write protect on
Date: Sun, 13 Jul 2008 12:33:21 -0700 (PDT)
Message-ID: <20080713193321.08F86108035@picon.linux-foundation.org>
References: <bug-10725-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986AbYGMTeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2008 15:34:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6DJXLQS016708
	for <linux-scsi@vger.kernel.org>; Sun, 13 Jul 2008 12:33:22 -0700
In-Reply-To: <bug-10725-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10725


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #4 from rjw@sisk.pl  2008-07-13 12:33 -------
Fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bdb2b8cab4392ce41ddfbd6773a3da3334daf836


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
