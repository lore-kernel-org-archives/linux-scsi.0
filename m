From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Wed, 14 Sep 2016 10:22:09 +0000
Message-ID: <bug-151661-11613-Kl3wolPMbA@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758398AbcINKWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 06:22:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5198D20451
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:22:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 1F9582047D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:22:10 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #16 from HE - IT Services <he001@fitmsg.net> ---
(In reply to Matthias from comment #14)
> you can find it in:
> drivers/scsi/aacraid/commsup.c
> in my 4.7.3 it is in Line 1700

Thanks Matthias.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
