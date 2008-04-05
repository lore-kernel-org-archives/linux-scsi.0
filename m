From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 10:18:52 -0700 (PDT)
Message-ID: <20080405171852.3256F108061@picon.linux-foundation.org>
References: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbYDERSy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 13:18:54 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35HIqco015231
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 10:18:53 -0700
In-Reply-To: <bug-10396-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396





------- Comment #8 from linux@tjworld.net  2008-04-05 10:18 -------
Created an attachment (id=15621)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=15621&action=view)
PowerEdge 6300 lspci -vxxx


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
