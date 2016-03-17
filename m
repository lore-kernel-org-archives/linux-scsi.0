From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] 3w-9xxx: DMA-API: device driver tries to free DMA memory
 it has not allocated
Date: Thu, 17 Mar 2016 20:37:19 +0000
Message-ID: <bug-91711-11613-5H9GQkPjNl@https.bugzilla.kernel.org/>
References: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52454 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935883AbcCQUhW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2016 16:37:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 07A3B2035E
	for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2016 20:37:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 249212034B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2016 20:37:20 +0000 (UTC)
In-Reply-To: <bug-91711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

--- Comment #2 from nickkrause@sympatico.ca ---
The patch I just attached about this may fix your issue.

-- 
You are receiving this mail because:
You are the assignee for the bug.
