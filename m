From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 29 Jul 2013 03:32:12 +0000
Message-ID: <bug-60644-11613-5VTvus2h8x@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58560 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab3G2DcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jul 2013 23:32:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 54F2F2013C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 03:32:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5C9B920122
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 03:32:12 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #2 from liveaxle@live.com ---
Kernel locks are rather "soft" , the machine functions but the HDDs activity
LED stays on and the kernel doesn't respond to a reboot or shutdown command
from console .

It has to be hard-reset using the power button .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
