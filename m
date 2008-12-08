From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12163] mptsas driver cannot discover some hotplugged SATA/SAS disks
Date: Sun,  7 Dec 2008 18:19:41 -0800 (PST)
Message-ID: <20081208021941.4030510800F@picon.linux-foundation.org>
References: <bug-12163-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbYLHCUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 21:20:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB82JfjF025390
	for <linux-scsi@vger.kernel.org>; Sun, 7 Dec 2008 18:19:42 -0800
In-Reply-To: <bug-12163-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12163





------- Comment #4 from crquan@gmail.com  2008-12-07 18:19 -------
I have tested and verified that this two patches can let my LSI-SAS-1068E
controllers work well with 2.6.26.2 kernels, perfect,

Tested-by: Cheng Renquan <crquan@gmail.com>

but the latest git kernel has not yet been tested. I personally suggest this
patch integrated into Greg KH's staging tree.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
