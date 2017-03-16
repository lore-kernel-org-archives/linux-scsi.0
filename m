From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Thu, 16 Mar 2017 16:18:34 +0000
Message-ID: <bug-194837-11613-KKE1c9ZM5Y@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44834 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752849AbdCPQT2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 12:19:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8FF8D2856B
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 16:18:42 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DA7562843C
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 16:18:41 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #14 from Thorsten Leemhuis (regressions@leemhuis.info) ---
Status update: Had a hunch and reverted the vhost/virtio changes
(https://git.kernel.org/torvalds/c/54d7989f476ca57fc3c5cc71524c480ccb74c481 )
on top of master and now it's running fine. Will look closer now which of the
changes is the culprit.

-- 
You are receiving this mail because:
You are the assignee for the bug.
