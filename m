From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156321] mpt3sas timeout with xen, works only with
 mpt3sas.msix_disable=1 (SAS3008 card)
Date: Sun, 02 Oct 2016 06:32:19 +0000
Message-ID: <bug-156321-11613-h9uiuuf3cX@https.bugzilla.kernel.org/>
References: <bug-156321-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbcJBGcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 2 Oct 2016 02:32:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D4FFC202C8
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 06:32:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id DE3DE202AE
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 06:32:19 +0000 (UTC)
In-Reply-To: <bug-156321-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156321

jwzr <john.wyzer@gmx.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #5 from jwzr <john.wyzer@gmx.de> ---
With the latest revision of the firmware (P13) this is no longer an issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
