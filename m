From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108621] kernel BUG in drivers/scsi/scsi_lib.c
Date: Mon, 30 Nov 2015 16:14:24 +0000
Message-ID: <bug-108621-11613-hy6dsr6PUn@https.bugzilla.kernel.org/>
References: <bug-108621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37097 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbbK3QO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 11:14:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4E052204D8
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 16:14:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D798020562
	for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2015 16:14:24 +0000 (UTC)
In-Reply-To: <bug-108621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108621

Bart Van Assche <bvanassche@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #1 from Bart Van Assche <bvanassche@acm.org> ---
Please have a look at the following e-mail thread:
http://thread.gmane.org/gmane.linux.kernel/2088075.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
