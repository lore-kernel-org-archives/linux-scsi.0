From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Wed,  3 Dec 2008 22:38:28 -0800 (PST)
Message-ID: <20081204063828.4676310800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbYLDGia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 01:38:30 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB46cSZV000676
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 22:38:29 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120


stefan-r-bz@s5r6.in-berlin.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
