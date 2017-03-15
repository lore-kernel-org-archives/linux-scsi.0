From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108621] kernel BUG in drivers/scsi/scsi_lib.c
Date: Wed, 15 Mar 2017 21:14:16 +0000
Message-ID: <bug-108621-11613-vVNJQSGBiL@https.bugzilla.kernel.org/>
References: <bug-108621-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42430 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751416AbdCOVOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 17:14:20 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2583428528
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 21:14:17 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B63D02861A
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 21:14:16 +0000 (UTC)
In-Reply-To: <bug-108621-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108621

Martin Ziegler (ziegler@uni-freiburg.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
