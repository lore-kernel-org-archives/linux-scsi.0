From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12762] Disk errors loop forever in 2.6.29
Date: Tue,  3 Mar 2009 14:14:26 -0800 (PST)
Message-ID: <20090303221426.851D7108041@picon.linux-foundation.org>
References: <bug-12762-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZCCWOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 17:14:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n23MEQ5f030529
	for <linux-scsi@vger.kernel.org>; Tue, 3 Mar 2009 14:14:27 -0800
In-Reply-To: <bug-12762-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12762


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #2 from rjw@sisk.pl  2009-03-03 14:14 -------
Fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=126c098296c8f96cf7f6ca0fdb47265ac7994f00


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
