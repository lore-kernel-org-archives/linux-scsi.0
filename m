From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 09:44:00 -0700 (PDT)
Message-ID: <20080405164400.9191F10805E@picon.linux-foundation.org>
References: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbYDEQoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 12:44:34 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35Gi0nd013012
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 09:44:01 -0700
In-Reply-To: <bug-10396-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396





------- Comment #4 from linux@tjworld.net  2008-04-05 09:44 -------
Created an attachment (id=15619)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=15619&action=view)
v.2.6.25-rc8 pci=noacpi (successful) boot log


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
