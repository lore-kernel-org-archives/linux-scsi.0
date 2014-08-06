From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Wed, 06 Aug 2014 21:16:19 +0000
Message-ID: <bug-80711-11613-G8LO5naGmN@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54713 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbaHFVQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 17:16:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5C4C520173
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 21:16:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3AB6A2018B
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 21:16:20 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #7 from Tiziano Bacocco <tiziano.bacocco@gmail.com> ---
Not when issuing vendor specific commands , even if the flash drive has only 1
LUN , there's the need of using these bits with LUN numbers higher than the
reported number of LUNs

-- 
You are receiving this mail because:
You are the assignee for the bug.
