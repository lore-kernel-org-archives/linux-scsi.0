From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Wed, 15 Mar 2017 07:02:43 +0000
Message-ID: <bug-194837-11613-vNmwA33VUE@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45242 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750988AbdCOHCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 03:02:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4BCDF285EF
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:02:46 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D2C41285AA
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 07:02:45 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #10 from Thorsten Leemhuis (linux@leemhuis.info) ---
(In reply to Thorsten Leemhuis from comment #9)
> (In reply to Omar Sandoval from comment #8)
>> This was fixed in v4.11-rc2.
> Care to provide a few more details and a commit that fixes this?

Okay, now assuming you mean
https://git.kernel.org/torvalds/c/737f98cfe7de8df7433a4d846850aa8efa44bd48 Will
investigate…

-- 
You are receiving this mail because:
You are the assignee for the bug.
