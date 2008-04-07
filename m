From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10411] [PATCH] scsi: fix sense_slab/bio swapping livelock
Date: Mon,  7 Apr 2008 09:01:19 -0700 (PDT)
Message-ID: <20080407160119.E9B2E108060@picon.linux-foundation.org>
References: <bug-10411-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbYDGQB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 12:01:59 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m37G1JPa021990
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 09:01:21 -0700
In-Reply-To: <bug-10411-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10411


bunk@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bunk@kernel.org
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #2 from bunk@kernel.org  2008-04-07 09:01 -------
fixed by commit 164fc5dcd6a1026fc713f5c63fad899aa484888c


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
