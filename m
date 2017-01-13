From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191381] LIO ignores XCOPY source and destination descriptor IDs
Date: Fri, 13 Jan 2017 10:42:03 +0000
Message-ID: <bug-191381-11613-x0klwlw1SN@https.bugzilla.kernel.org/>
References: <bug-191381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdAMKmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Jan 2017 05:42:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 768B8204A0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 10:42:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id F00EB204A2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 10:42:03 +0000 (UTC)
In-Reply-To: <bug-191381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191381

David Disseldorp <ddiss.dev@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from David Disseldorp <ddiss.dev@gmail.com> ---
LIO XCOPY fixes merged to Linus' tree:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=87156518da94a696f2b27ab8945d531af2f1d339&showmsg=1

-- 
You are receiving this mail because:
You are the assignee for the bug.
