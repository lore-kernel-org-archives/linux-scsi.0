From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48871] drivers/scsi/lpfc/lpfc_init.c: 2 * Buffer is accessed
 out of bounds
Date: Sat, 22 Dec 2012 09:18:56 +0000 (UTC)
Message-ID: <20121222091856.CAB1611FF02@bugzilla.kernel.org>
References: <bug-48871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54155 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab2LVJTH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2012 04:19:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF53B2015D
	for <linux-scsi@vger.kernel.org>; Sat, 22 Dec 2012 09:19:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0D23B2015C
	for <linux-scsi@vger.kernel.org>; Sat, 22 Dec 2012 09:18:58 +0000 (UTC)
In-Reply-To: <bug-48871-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48871


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-12-22 09:18:56 ---
A patch referencing this bug report has been merged in Linux v3.8-rc1:

commit 8c1312e1b9dae446af17d5a5f11c325cbb4c9103
Author: James Smart <james.smart@emulex.com>
Date:   Wed Oct 31 14:45:09 2012 -0400

    [SCSI] lpfc 8.3.36: Correct buffer length overrun

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
