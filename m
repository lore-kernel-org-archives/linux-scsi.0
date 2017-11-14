From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Tue, 14 Nov 2017 22:26:27 +0000
Message-ID: <bug-197875-11613-mjcqpcVdRf@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36812 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754143AbdKNW03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 17:26:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6697429A9B
        for <linux-scsi@vger.kernel.org>; Tue, 14 Nov 2017 22:26:29 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
Please provide the output of the following command after having reproduced the
hang:

    dmesg -c >/dev/null; echo w > /proc/sysrq-trigger; dmesg

Additionally, if you know how to build the kernel yourself, it would be helpful
if you could bisect this issue. Documentation is available e.g. at
https://git-scm.com/docs/git-bisect.

-- 
You are receiving this mail because:
You are the assignee for the bug.
