From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Thu,  5 Feb 2009 13:12:10 -0800 (PST)
Message-ID: <20090205211210.B13FB108043@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbZBEVMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2009 16:12:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n15LCAeQ014810
	for <linux-scsi@vger.kernel.org>; Thu, 5 Feb 2009 13:12:11 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #19 from stern@rowland.harvard.edu  2009-02-05 13:12 -------
Created an attachment (id=20126)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20126&action=view)
Increase max_sectors for tape drives

Phil, are you still there?  This is the patch in the form I intend to submit. 
Does it fix your problem?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
