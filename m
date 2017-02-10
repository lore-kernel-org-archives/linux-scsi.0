From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Fri, 10 Feb 2017 09:23:36 +0000
Message-ID: <bug-151661-11613-CKxsTChL8l@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49962 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752109AbdBJJYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Feb 2017 04:24:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2DEE32856D
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 09:23:48 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 630C228559
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 09:23:47 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #19 from Arkadiusz Miskiewicz (arekm@maven.pl) ---
Fix:

http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/patch/?id=8af8e1c22f9994bb1849c01d66c24fe23f9bc9a0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
