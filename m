From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48891] scsi/lpfc/lpfc_ct.c:637: possible finger trouble ?
Date: Sat, 22 Dec 2012 09:28:23 +0000 (UTC)
Message-ID: <20121222092823.CE2B511FBAA@bugzilla.kernel.org>
References: <bug-48891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2LVJ2i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2012 04:28:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CEECF20153
	for <linux-scsi@vger.kernel.org>; Sat, 22 Dec 2012 09:28:36 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D076220155
	for <linux-scsi@vger.kernel.org>; Sat, 22 Dec 2012 09:28:23 +0000 (UTC)
In-Reply-To: <bug-48891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48891


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-12-22 09:28:23 ---
A patch referencing this bug report has been merged in Linux v3.8-rc1:

commit edb22f06e08ac5b25ae2d9ad10ae31ac58ca0de4
Author: James Smart <james.smart@emulex.com>
Date:   Wed Oct 31 14:45:21 2012 -0400

    [SCSI] lpfc 8.3.36: Correct mask error

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
