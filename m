From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111381] mvsas 0.8.16 on Marvell 88SE9485 reports timeouts on
 load
Date: Fri, 05 Feb 2016 16:33:03 +0000
Message-ID: <bug-111381-11613-k8tz3tLnRA@https.bugzilla.kernel.org/>
References: <bug-111381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55357 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbcBEQdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Feb 2016 11:33:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 525C520395
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:33:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D0D5E20383
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:33:03 +0000 (UTC)
In-Reply-To: <bug-111381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111381

--- Comment #3 from Gabriel A. Devenyi <gdevenyi@gmail.com> ---
Recently problems very similar to this showed up in a discussion on reddit.

See
https://www.reddit.com/r/zfs/comments/43z0sn/scrub_knocked_a_drive_offline_flaky_hardware_other/

It kinda looks like Marvell controllers (or the mvsas driver?) are sensitive to
cable length.

I'm looking at halving the length of my cabling, will report back if the issues
resolve.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
