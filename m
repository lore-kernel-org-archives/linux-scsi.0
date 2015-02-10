From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93051] Oops in kmem_cache_alloc / scsi_host_alloc_command
Date: Tue, 10 Feb 2015 16:56:37 +0000
Message-ID: <bug-93051-11613-WzERLydR3D@https.bugzilla.kernel.org/>
References: <bug-93051-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbbBJQ4k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 11:56:40 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 37EBA2012E
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 16:56:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9B40920154
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2015 16:56:37 +0000 (UTC)
In-Reply-To: <bug-93051-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=93051

--- Comment #1 from Nathan R <nathan.renniewaldock+kernelbugs@gmail.com> ---
Created attachment 166351
  --> https://bugzilla.kernel.org/attachment.cgi?id=166351&action=edit
oops 2015-01-31 (1)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
