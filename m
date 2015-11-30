From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108621] kernel BUG in drivers/scsi/scsi_lib.c
Date: Mon, 30 Nov 2015 17:13:41 +0000
Message-ID: <bug-108621-11613-sZO7sn63Cm@https.bugzilla.kernel.org/>
References: <bug-108621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbK3RNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 12:13:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3AFB420573
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 17:13:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1BBF0205B1
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 17:13:42 +0000 (UTC)
In-Reply-To: <bug-108621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108621

--- Comment #2 from Martin Ziegler <ziegler@uni-freiburg.de> ---
So I better wait for 4.4-rc4...

Thanks,

Martin

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
