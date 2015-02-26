From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Thu, 26 Feb 2015 07:32:18 +0000
Message-ID: <bug-90601-11613-VVs5t5tyFI@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42533 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbbBZHcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2015 02:32:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BEB42038C
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2015 07:32:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7A9E420384
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2015 07:32:19 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #14 from merlin@liao.homelinux.org ---
@Kashyap

For me it started with 3.16 on all our servers with 3ware/lsi/avagotech
controllers.
I rechecked in our internal ticket system.

We are using IOMMU so I completely disabled it, recompiled the kernal but
getting the same error.

I also attached my kernel config before so maybe you can use that config and
compile the kernel on your side.
Running with that config I can reproduce the crash with a simple dd command:
dd if=/dev/zero of=test bs=1G count=10

-- 
You are receiving this mail because:
You are the assignee for the bug.
