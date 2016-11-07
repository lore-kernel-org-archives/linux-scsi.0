From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Mon, 07 Nov 2016 15:25:11 +0000
Message-ID: <bug-187231-11613-FBrg8UfG6O@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbcKGPZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 10:25:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5E27D20218
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 15:25:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 02FFE2022D
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 15:25:12 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

Don <don.brace@microsemi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |don.brace@microsemi.com

--- Comment #1 from Don <don.brace@microsemi.com> ---
Created attachment 243811
  --> https://bugzilla.kernel.org/attachment.cgi?id=243811&action=edit
Patch to correct resets

I will be uploading this patch to linux-scsi this week.

I am attaching the patch in case you would like to test this patch now.

-- 
You are receiving this mail because:
You are the assignee for the bug.
