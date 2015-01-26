From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 91711] 3w-9xxx: DMA-API: device driver tries to free DMA memory
 it has not allocated
Date: Mon, 26 Jan 2015 12:56:43 +0000
Message-ID: <bug-91711-11613-GVum8A9A46@https.bugzilla.kernel.org/>
References: <bug-91711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbbAZM4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2015 07:56:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BE1D20142
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 12:56:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 770A420125
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2015 12:56:43 +0000 (UTC)
In-Reply-To: <bug-91711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=91711

Orion <admin@e-blokos.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|SCSI                        |Other
            Product|IO/Storage                  |SCSI Drivers

-- 
You are receiving this mail because:
You are the assignee for the bug.
