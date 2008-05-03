From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6695] Dell CERC ATA100/4ch not supported by any driver in 2.6.16
Date: Sat,  3 May 2008 10:35:27 -0700 (PDT)
Message-ID: <20080503173527.03146108064@picon.linux-foundation.org>
References: <bug-6695-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757363AbYECRn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 13:43:59 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m43HhOod030835
	for <linux-scsi@vger.kernel.org>; Sat, 3 May 2008 10:43:25 -0700
In-Reply-To: <bug-6695-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6695


bunk@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #18 from bunk@kernel.org  2008-05-03 10:35 -------
fixed by commit 69cd39e94669e2994277a29249b6ef93b088ddbb (will be in 2.6.26)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
