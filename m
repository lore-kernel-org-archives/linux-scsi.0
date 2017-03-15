From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Wed, 15 Mar 2017 06:57:52 +0000
Message-ID: <bug-194837-11613-620wVv6HwF@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44848 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751461AbdCOG54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 02:57:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F3C0D285F0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 06:57:54 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5ADB4285F0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 06:57:54 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #9 from Thorsten Leemhuis (linux@leemhuis.info) ---
(In reply to Omar Sandoval from comment #8)
> This was fixed in v4.11-rc2.

Care to provide a few more details and a commit that fixes this? Because I'm
still seeing crashes with 4.11-rc2; but a few details looks fishy and I more
and more wonder if I'm dealing with two bugs here :-/

-- 
You are receiving this mail because:
You are the assignee for the bug.
