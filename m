From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 06 Jul 2016 16:15:26 +0000
Message-ID: <bug-121531-11613-Mu74wHUr14@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbcGFQPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 12:15:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AC1972012D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 16:15:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5E35520122
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 16:15:27 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

Jack Wang <xjtuwjp@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xjtuwjp@gmail.com

--- Comment #11 from Jack Wang <xjtuwjp@gmail.com> ---
Have you tried the version from microsemi? they have a lot of changes which are
not
in upstream: 
http://storage.microsemi.com/en-us/support/sas/sas/asa-7805h/

-- 
You are receiving this mail because:
You are the assignee for the bug.
