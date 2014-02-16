From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70271] rmmod st causes general protection fault
Date: Sun, 16 Feb 2014 03:30:06 +0000
Message-ID: <bug-70271-11613-6Vz61eRdXf@https.bugzilla.kernel.org/>
References: <bug-70271-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbaBPDaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Feb 2014 22:30:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 24736201F5
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2014 03:30:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1C531201F9
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2014 03:30:08 +0000 (UTC)
In-Reply-To: <bug-70271-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70271

Andreas Steinmetz <ast@domdv.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from Andreas Steinmetz <ast@domdv.de> ---
Verified the patch. Fixes the Oops. Thanks a lot.

-- 
You are receiving this mail because:
You are the assignee for the bug.
