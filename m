From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] 3w-9xxx: DMA-API: device driver tries to free DMA memory
 it has not allocated
Date: Fri, 18 Mar 2016 18:52:23 +0000
Message-ID: <bug-91711-11613-p1qrMZU8aJ@https.bugzilla.kernel.org/>
References: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbcCRSw3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 14:52:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E3E8E20351
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 18:52:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3006920373
	for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2016 18:52:24 +0000 (UTC)
In-Reply-To: <bug-91711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

--- Comment #18 from nickkrause@sympatico.ca ---
Those patches may fix it but I am pretty sure those patches are in the 3.18.3
kernel release back port. Maybe I am work but let Orion test those patches too
to see if those should be back ported or are already there.

-- 
You are receiving this mail because:
You are the assignee for the bug.
