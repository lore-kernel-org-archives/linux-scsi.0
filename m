From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120371] UBSAN splat in drivers/scsi/scsi_devinfo.c:458:21
Date: Wed, 22 Feb 2017 20:06:03 +0000
Message-ID: <bug-120371-11613-9PsirmkWx2@https.bugzilla.kernel.org/>
References: <bug-120371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59488 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932214AbdBVUGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 15:06:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0569B284DC
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2017 20:06:06 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C18F628683
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2017 20:06:03 +0000 (UTC)
In-Reply-To: <bug-120371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120371

Wilfried Klaebe (linux-kernel@lebenslange-mailadresse.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from Wilfried Klaebe (linux-kernel@lebenslange-mailadresse.de) ---
does not appear anymore in (at least) 4.10

-- 
You are receiving this mail because:
You are the assignee for the bug.
