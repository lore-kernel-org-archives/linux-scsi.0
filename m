From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] 3w-9xxx: DMA-API: device driver tries to free DMA memory
 it has not allocated
Date: Fri, 18 Mar 2016 14:38:42 +0000
Message-ID: <bug-91711-11613-KEdLy7uYqo@https.bugzilla.kernel.org/>
References: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57860 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbcCROit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 10:38:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE540202E9
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 14:38:48 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 64C4A2037F
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 14:38:44 +0000 (UTC)
In-Reply-To: <bug-91711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

--- Comment #16 from Orion <admin@e-blokos.com> ---
ok thanks. the best would be to check if another guys can test it also

-- 
You are receiving this mail because:
You are the assignee for the bug.
