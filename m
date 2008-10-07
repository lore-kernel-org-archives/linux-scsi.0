From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Tue,  7 Oct 2008 14:27:02 -0700 (PDT)
Message-ID: <20081007212702.2EAFD108047@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbYJGV1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 17:27:35 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m97LR2PB018298
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 14:27:03 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #13 from seokmann.ju@qlogic.com  2008-10-07 14:27 -------
OK. I see your point.
Could you provide feedback on the questions that I've raised in the email?
Let's continue to narrow down the problem further.
One thing, we would need to have console output redirected to serial as it
reveals most accurate clues for us.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
