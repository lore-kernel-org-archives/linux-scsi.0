From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12240] Disk errors sometimes ignored from the USB-SCSI layer
Date: Wed, 30 May 2012 11:40:10 +0000 (UTC)
Message-ID: <20120530114010.0F54F11FD27@bugzilla.kernel.org>
References: <bug-12240-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab2E3LkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 07:40:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0A2C920388
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2012 11:40:15 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 4D522203AD
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2012 11:40:12 +0000 (UTC)
In-Reply-To: <bug-12240-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=12240


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX
         Regression|---                         |No




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-05-30 11:40:09 ---
f1a0743bc0e7a30c032b1eb78f6a2b0f805b4597

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
