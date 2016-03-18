From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] 3w-9xxx: DMA-API: device driver tries to free DMA memory
 it has not allocated
Date: Fri, 18 Mar 2016 14:13:46 +0000
Message-ID: <bug-91711-11613-icW5ghRVJV@https.bugzilla.kernel.org/>
References: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53950 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055AbcCRONy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 10:13:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E147B20390
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 14:13:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 07CE320389
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 14:13:47 +0000 (UTC)
In-Reply-To: <bug-91711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

--- Comment #12 from Orion <admin@e-blokos.com> ---
how can I mark tested on your patch?

-- 
You are receiving this mail because:
You are the assignee for the bug.
