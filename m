From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Wed, 14 Sep 2016 10:18:52 +0000
Message-ID: <bug-151661-11613-p1czjBVt4I@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756056AbcINKS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 06:18:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 417D52047C
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:18:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 326542049D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:18:53 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

Matthias <hm10439@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hm10439@gmail.com

--- Comment #14 from Matthias <hm10439@gmail.com> ---
you can find it in:
drivers/scsi/aacraid/commsup.c
in my 4.7.3 it is in Line 1700

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
