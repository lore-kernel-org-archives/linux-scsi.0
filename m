From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34522] Error-valued pointer overwrite in SCSI
Date: Sat, 12 May 2012 14:15:29 +0000 (UTC)
Message-ID: <20120512141529.8AA9011FCE2@bugzilla.kernel.org>
References: <bug-34522-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab2ELOPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2012 10:15:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3452B2037D
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 14:15:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 903F620375
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 14:15:29 +0000 (UTC)
In-Reply-To: <bug-34522-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=34522


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
