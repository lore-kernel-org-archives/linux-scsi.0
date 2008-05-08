From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10622] [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Thu,  8 May 2008 16:56:00 -0700 (PDT)
Message-ID: <20080508235600.15C9C108063@picon.linux-foundation.org>
References: <bug-10622-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbYEHX4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 19:56:34 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m48Nu1GS001476
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2008 16:56:02 -0700
In-Reply-To: <bug-10622-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10622





------- Comment #2 from dan.j.williams@intel.com  2008-05-08 16:55 -------
The patch at http://marc.info/?l=linux-raid&m=121001065404056&w=2 addresses a
different issue: "WARNING: at include/linux/blkdev.h:443"


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
