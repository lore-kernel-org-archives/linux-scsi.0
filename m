From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112241] Under heavy load FC TARGET going to Oops
Date: Mon, 29 Feb 2016 02:24:47 +0000
Message-ID: <bug-112241-11613-J5R9DbFCFD@https.bugzilla.kernel.org/>
References: <bug-112241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39557 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbcB2CZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Feb 2016 21:25:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C1FF620265
	for <linux-scsi@vger.kernel.org>; Mon, 29 Feb 2016 02:24:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 744362027D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Feb 2016 02:24:56 +0000 (UTC)
In-Reply-To: <bug-112241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=112241

--- Comment #1 from Anthony <anthony.bloodoff@gmail.com> ---
Created attachment 206351
  --> https://bugzilla.kernel.org/attachment.cgi?id=206351&action=edit
Screenshot with call trace for kernel 4.5.0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
