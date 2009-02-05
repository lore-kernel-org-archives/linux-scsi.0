From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Thu,  5 Feb 2009 13:48:41 -0800 (PST)
Message-ID: <20090205214841.34304108042@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754286AbZBEVtb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2009 16:49:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n15Lmf5v017917
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2009 13:48:42 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #20 from philipm@sybase.com  2009-02-05 13:48 -------
Yes, sorry.  I meant to get back to you but time has been tight.  As such, I
still haven't had a chance to recompile a kernel and try it out.  I agree that
the patch will probably fix the problem.  I'll do my best to find some time to
try it out within the next week.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
