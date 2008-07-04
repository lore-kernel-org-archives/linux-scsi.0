From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10730] build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined reference to `request_firmware'
Date: Fri,  4 Jul 2008 14:40:53 -0700 (PDT)
Message-ID: <20080704214053.5B5B711D107@picon.linux-foundation.org>
References: <bug-10730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbYGDVsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 17:48:50 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m64LmKAm008051
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jul 2008 14:48:21 -0700
In-Reply-To: <bug-10730-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10730


bunk@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #2 from bunk@kernel.org  2008-07-04 14:40 -------
fixed by commit 69d44a1835ec8163a82c4ee57367f87ae0f85c2e


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
