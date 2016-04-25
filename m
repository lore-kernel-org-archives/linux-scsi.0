From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116751] Double-Fetch bug in
 Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Mon, 25 Apr 2016 16:23:01 +0000
Message-ID: <bug-116751-11613-gJFeJfDMe0@https.bugzilla.kernel.org/>
References: <bug-116751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbcDYQXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:23:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DC8F0201FA
	for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2016 16:23:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 70DC5201BB
	for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2016 16:23:01 +0000 (UTC)
In-Reply-To: <bug-116751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=116751

--- Comment #1 from Pengfei Wang <wpengfeinudt@gmail.com> ---
Created attachment 214111
  --> https://bugzilla.kernel.org/attachment.cgi?id=214111&action=edit
source file

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
