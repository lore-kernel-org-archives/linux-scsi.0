From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10050] message/fusion/mptbase.c: fix use-after-free's
Date: Sun, 24 Feb 2008 23:57:18 -0800 (PST)
Message-ID: <20080225075718.E6F98108077@picon.linux-foundation.org>
References: <bug-10050-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYBYH5r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 02:57:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1P7vIeW004980
	for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 23:57:20 -0800
In-Reply-To: <bug-10050-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10050


bunk@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #1 from bunk@kernel.org  2008-02-24 23:57 -------
Fixed by commit ad008d42bcec99911b3270a8349f8ec8405a1c4e.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
