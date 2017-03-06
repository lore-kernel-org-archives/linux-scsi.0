From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108621] kernel BUG in drivers/scsi/scsi_lib.c
Date: Mon, 06 Mar 2017 20:15:00 +0000
Message-ID: <bug-108621-11613-bMjGMVDeS3@https.bugzilla.kernel.org/>
References: <bug-108621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40790 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753171AbdCFUdR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 15:33:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B05DA283BA
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2017 20:15:00 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 45E6828306
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2017 20:15:00 +0000 (UTC)
In-Reply-To: <bug-108621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108621

Szőgyényi Gábor (szg0000@freemail.hu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |szg0000@freemail.hu

--- Comment #3 from Szőgyényi Gábor (szg0000@freemail.hu) ---
Please try to reproduce this bug with latest kernel image.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
