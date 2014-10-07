From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85751] iSCSI initiator lockup during login
Date: Tue, 07 Oct 2014 15:49:52 +0000
Message-ID: <bug-85751-11613-sLYfb1Jymk@https.bugzilla.kernel.org/>
References: <bug-85751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaJGPt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 11:49:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9982120220
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 15:49:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4D0C820221
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 15:49:53 +0000 (UTC)
In-Reply-To: <bug-85751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85751

Sagi Grimberg <sagig@dev.mellanox.co.il> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sagig@dev.mellanox.co.il

--- Comment #1 from Sagi Grimberg <sagig@dev.mellanox.co.il> ---
Hey Bart,

Any chance you provide on the scenario you used to reproduce this issue?
did you simply login and got it?
is it a firm reproduce?

-- 
You are receiving this mail because:
You are the assignee for the bug.
