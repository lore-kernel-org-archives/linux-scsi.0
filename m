From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Fri, 17 Mar 2017 19:02:59 +0000
Message-ID: <bug-194837-11613-3vP3WkSW3v@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59666 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751131AbdCQTDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Mar 2017 15:03:37 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F3EE228506
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 19:03:00 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9138C28593
        for <linux-scsi@vger.kernel.org>; Fri, 17 Mar 2017 19:02:59 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #15 from Thorsten Leemhuis (regressions@leemhuis.info) ---
Adam or somebody else: Can you please close this Bug to avoid confusion? There
clearly were some bugs in virtio_scsi, but those were already fixed. 

But there are more bugs (at least for me): I bisectected the problem I'm still
seeing with todays mainline and found that "virtio_pci: use shared interrupts
for virtqueues" (5c34d002dcc7; from hch and mst) was the first bad commit for
me. Filed Bug 194911 to track that.

-- 
You are receiving this mail because:
You are the assignee for the bug.
