From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Tue, 18 Oct 2016 10:18:27 +0000
Message-ID: <bug-153171-11613-yfE5BMJSBM@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758088AbcJRKSg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 06:18:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 963EB202EB
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 10:18:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 77B3320222
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 10:18:27 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

Scott Mowerson <smowerson@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |smowerson@gmail.com

--- Comment #10 from Scott Mowerson <smowerson@gmail.com> ---
This is preventing me from booting Ubuntu 16.10:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1631058?comments=all 

But I am not using a low-latency kernel.

-- 
You are receiving this mail because:
You are the assignee for the bug.
