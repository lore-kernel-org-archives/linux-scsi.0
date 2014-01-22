From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69201] qla2xxx: Low-latency storage triggers lock contention
Date: Wed, 22 Jan 2014 09:47:51 +0000
Message-ID: <bug-69201-11613-A8uOcLhzGh@https.bugzilla.kernel.org/>
References: <bug-69201-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaAVJry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jan 2014 04:47:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4044320173
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 09:47:53 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C228720161
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 09:47:51 +0000 (UTC)
In-Reply-To: <bug-69201-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=69201

--- Comment #1 from Bart Van Assche <bvanassche@acm.org> ---
Created attachment 123011
  --> https://bugzilla.kernel.org/attachment.cgi?id=123011&action=edit
perf report --stdio output

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
