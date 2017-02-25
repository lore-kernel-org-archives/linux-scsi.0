From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120371] UBSAN splat in drivers/scsi/scsi_devinfo.c:458:21
Date: Sat, 25 Feb 2017 09:31:51 +0000
Message-ID: <bug-120371-11613-rkEh9yLbDc@https.bugzilla.kernel.org/>
References: <bug-120371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35950 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751419AbdBYJnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Feb 2017 04:43:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0550628672
        for <linux-scsi@vger.kernel.org>; Sat, 25 Feb 2017 09:31:52 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7469C28678
        for <linux-scsi@vger.kernel.org>; Sat, 25 Feb 2017 09:31:51 +0000 (UTC)
In-Reply-To: <bug-120371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120371

Wilfried Klaebe (linux-kernel@lebenslange-mailadresse.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

-- 
You are receiving this mail because:
You are the assignee for the bug.
