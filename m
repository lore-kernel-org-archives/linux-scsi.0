From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Mon, 13 Mar 2017 15:04:36 +0000
Message-ID: <bug-194837-11613-Bsek2e3BRx@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37200 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750820AbdCMPEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 11:04:38 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 443F128490
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 15:04:37 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C7CB9284D8
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 15:04:36 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

Thorsten Leemhuis (linux@leemhuis.info) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux@leemhuis.info

--- Comment #3 from Thorsten Leemhuis (linux@leemhuis.info) ---
Seeing this also (RHEL Host, KVM)

Adam, did you report this here only or also to some mailinglist?

-- 
You are receiving this mail because:
You are the assignee for the bug.
