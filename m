From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42939] hv_storvsc - write cache enabled by default and cannot
 be disabled
Date: Mon, 19 Mar 2012 19:36:47 GMT
Message-ID: <201203191936.q2JJal3M027532@bugzilla.kernel.org>
References: <bug-42939-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:45133 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030956Ab2CSTgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 15:36:48 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2JJalEA027533
	for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:36:47 GMT
In-Reply-To: <bug-42939-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42939





--- Comment #2 from Mark <bugzilla-kernel-org-sux2k0@mstier.de>  2012-03-19 19:36:47 ---
Additional information (5):

I'm getting 1.000 subsequent (serialized and small -- integer inserts)
transactions done (locally) within 2.2 seconds -- with InnoDB ACID transactions
(ie. full data transaction sync enabled). Isn't that a bit too fast for cheap
SATA disks in a RAID10 config?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
