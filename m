From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10186] SCSI_AIC94XX must depend on SCSI
Date: Fri, 28 Mar 2008 15:56:45 -0700 (PDT)
Message-ID: <20080328225645.3EEEA11D10B@picon.linux-foundation.org>
References: <bug-10186-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbYC1W5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:57:16 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2SMuj27021760
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 15:56:46 -0700
In-Reply-To: <bug-10186-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10186


bunk@kernel.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #1 from bunk@kernel.org  2008-03-28 15:56 -------
fixed by commit 67951f63807328b81e45c3c87af049c55c0a0081


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
