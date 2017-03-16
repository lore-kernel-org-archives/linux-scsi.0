From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Thu, 16 Mar 2017 12:49:44 +0000
Message-ID: <bug-194837-11613-Qs6RQ7aniV@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42482 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdCPMtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 08:49:46 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 19664285ED
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 12:49:45 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7521C285B5
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 12:49:44 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #13 from Thorsten Leemhuis (linux@leemhuis.info) ---
(In reply to Omar Sandoval from comment #11)
>
> If you are still seeing crashes on -rc2, could you please report it to
> linux-block@vger.kernel.org?

FWIW, these are the crashes I see:
https://plus.google.com/+ThorstenLeemhuis/posts/FjyyGjNtrrG But those happen
without virtio-scsi as well.

-- 
You are receiving this mail because:
You are the assignee for the bug.
