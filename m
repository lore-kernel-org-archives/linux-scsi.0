From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Thu, 09 Mar 2017 23:58:57 +0000
Message-ID: <bug-194837-11613-LqiCRzAxOa@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56646 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750781AbdCIX7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 18:59:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D5EB2286CF
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2017 23:58:59 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 48BF5286CF
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2017 23:58:58 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #1 from Adam Williamson (adamw@happyassassin.net) ---
Downstream bug is https://bugzilla.redhat.com/show_bug.cgi?id=1430043 , Fedora
kernel maintainers can provide info on the delta between the affected kernel
builds, I hope. The changelog just says:

* Mon Mar 06 2017 Laura Abbott - 4.11.0-0.rc1.git0.1
- Linux v4.11-rc1

* Mon Mar 06 2017 Laura Abbott
- Disable debugging options.

* Fri Mar 03 2017 Laura Abbott - 4.11.0-0.rc0.git9.1
- Linux v4.10-11319-gc82be9d

so the delta is to 'v4.10-11319-gc82be9d', but I dunno what that means exactly.

-- 
You are receiving this mail because:
You are the assignee for the bug.
