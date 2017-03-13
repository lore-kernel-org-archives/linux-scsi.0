From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Mon, 13 Mar 2017 15:15:19 +0000
Message-ID: <bug-194837-11613-txDtMWunJB@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38260 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751659AbdCMPPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 11:15:30 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E5B2528480
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 15:15:28 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B610828480
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2017 15:15:28 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #4 from Thorsten Leemhuis (linux@leemhuis.info) ---
(In reply to Adam Williamson from comment #1)
> so the delta is to 'v4.10-11319-gc82be9d', but I dunno what that means
> exactly.

FWIW, most likely suspects afaics: the second batches with changes to KVM and
SCSI
https://git.kernel.org/torvalds/c/2d62e0768d3c28536d4cfe4c40ba1e5e8e442a93
https://git.kernel.org/torvalds/c/a3b4924b027f9a4b95ce89a914c1e0459e76f18a

-- 
You are receiving this mail because:
You are the assignee for the bug.
