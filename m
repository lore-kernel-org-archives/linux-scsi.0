From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] Block SCSI Generic Driver does not maintain file handle
 context
Date: Fri, 15 Nov 2013 15:55:29 +0000
Message-ID: <bug-64171-11613-YYztU13nQS@https.bugzilla.kernel.org/>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3KOPzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Nov 2013 10:55:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DCFB4208B3
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2013 15:55:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C25032095C
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2013 15:55:29 +0000 (UTC)
In-Reply-To: <bug-64171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

Andrew Falanga <af300wsm@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Block SCSI Generic Driver   |Block SCSI Generic Driver
                   |does not keep data          |does not maintain file
                   |                            |handle context

--- Comment #4 from Andrew Falanga <af300wsm@gmail.com> ---
Changed the summary to actually complete a thought.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
