From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 192281] support of USB controller: NEC Corporation uPD720200
 USB 3.0 Host Controller (rev 03) (prog-if 30 [XHCI]) is broken
Date: Tue, 10 Jan 2017 22:16:32 +0000
Message-ID: <bug-192281-11613-nCLDOX6BO6@https.bugzilla.kernel.org/>
References: <bug-192281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752868AbdAJWQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Jan 2017 17:16:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id CD9CA20225
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2017 22:16:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 6C44D20251
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2017 22:16:32 +0000 (UTC)
In-Reply-To: <bug-192281-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=192281

--- Comment #1 from Slava <dbazim@gmail.com> ---
USB3.0 driver works ok if connected to USB2.0. It worked ok with Ubuntu 12.04
and have problems after upgrade to Ubuntu 16.04.

-- 
You are receiving this mail because:
You are the assignee for the bug.
