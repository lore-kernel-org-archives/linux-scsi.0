From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193041] iSCSI initiator: mkfs.ext4 + mount triggers kernel oops
Date: Wed, 01 Feb 2017 00:15:47 +0000
Message-ID: <bug-193041-11613-TkIpGd9rr2@https.bugzilla.kernel.org/>
References: <bug-193041-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbdBAAQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 19:16:31 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 2EFDE201BB
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2017 00:15:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 3642A201EF
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2017 00:15:47 +0000 (UTC)
In-Reply-To: <bug-193041-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=193041

Bart Van Assche <bvanassche@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #1 from Bart Van Assche <bvanassche@acm.org> ---
Fixed in v4.10-rc6 by commit 08965c2eba135bdfb6e86cf25308e01421c7e0ce (Revert
"sd: remove __data_len hack for WRITE SAME").

-- 
You are receiving this mail because:
You are the assignee for the bug.
