From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Sun, 22 Jun 2008 12:31:56 -0700 (PDT)
Message-ID: <20080622193156.CE8CF108035@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbYFVTb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2008 15:31:58 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5MJVuo3031019
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2008 12:31:57 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861


kay.sievers@vrfy.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kay.sievers@vrfy.org




------- Comment #4 from kay.sievers@vrfy.org  2008-06-22 12:31 -------
The udev rules are "broken"/insufficient. If they can't be updated with a
simple fix, the kernel should be compiled with CONFIG_SYSFS_DEPRECATED=y, which
keeps old userspace happy, and should avoid this issue.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
