From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108771] scsi: ses: kasan: ses_enclosure_data_process use after
 free on boot SAS2X28
Date: Fri, 30 Dec 2016 09:54:30 +0000
Message-ID: <bug-108771-11613-PGT5pmQJ1B@https.bugzilla.kernel.org/>
References: <bug-108771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752275AbcL3Jye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Dec 2016 04:54:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3EFAD20557
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 09:54:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 3DCE12054A
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 09:54:31 +0000 (UTC)
In-Reply-To: <bug-108771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108771

Pavel Tikhomirov <ptikhomirov@virtuozzo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
