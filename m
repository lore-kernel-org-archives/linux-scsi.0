From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Fri, 13 Feb 2015 07:54:30 +0000
Message-ID: <bug-90601-11613-34En7Il6KV@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbbBMHyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 02:54:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 90E9120274
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 07:54:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5E11D20268
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 07:54:30 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #10 from Alex Elsayed <eternaleye+kernelbugs@gmail.com> ---
Testing with 3.19 shows it's still there for me.

-- 
You are receiving this mail because:
You are the assignee for the bug.
