From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66611] Very Slow I/O performance on SAS1064
Date: Wed, 09 Nov 2016 19:40:58 +0000
Message-ID: <bug-66611-11613-fQbnRzl6lO@https.bugzilla.kernel.org/>
References: <bug-66611-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752977AbcKITlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 14:41:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 51E4120373
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 19:41:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 5B1A92037C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2016 19:40:58 +0000 (UTC)
In-Reply-To: <bug-66611-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=66611

Szőgyényi Gábor <szg0000@freemail.hu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |szg0000@freemail.hu

--- Comment #3 from Szőgyényi Gábor <szg0000@freemail.hu> ---
Please try this bug with latest kernel image.

-- 
You are receiving this mail because:
You are the assignee for the bug.