From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Tue, 08 Nov 2016 16:01:26 +0000
Message-ID: <bug-187231-11613-uUHVVa8p9E@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752978AbcKHQBe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 11:01:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 49D6F2025B
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2016 16:01:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 367F020279
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2016 16:01:27 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

--- Comment #4 from Patrick Schaaf <kernelorg@bof.de> ---
That problematic box, which showed the kernel panic with 4.8.6, and the
resetting/reset-up-to-20-seconds pauses several times a day with both 4.8 and
4.4.x, has now been running on 3.14.79 (with the same kvm load as before), for
30 hours, without any such HPSA resetting symptoms, or untoward pauses in the
VMs that I could otherwise notice in monitoring.

So somehow 3.14 does not trigger these episodes, or so it seems.

-- 
You are receiving this mail because:
You are the assignee for the bug.
