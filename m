From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101371] OOPS: unplugging western digital passport drive
Date: Mon, 20 Jul 2015 14:41:49 +0000
Message-ID: <bug-101371-11613-qQrykRgEEx@https.bugzilla.kernel.org/>
References: <bug-101371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42572 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbGTOlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jul 2015 10:41:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5A92920656
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2015 14:41:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EF9DB2064B
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2015 14:41:49 +0000 (UTC)
In-Reply-To: <bug-101371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101371

--- Comment #2 from Ilan Cohen <ilanco@gmail.com> ---
Hi Joe,

I applied the patch Alan posted to kernel 4.0.8 and the crash does not occur
anymore.

Regards,

Ilan Cohen

-- 
You are receiving this mail because:
You are the assignee for the bug.
