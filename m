From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198111] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
 [swapper/0:0] [libahci]
Date: Sat, 09 Dec 2017 17:58:04 +0000
Message-ID: <bug-198111-11613-XvH1J0Kcp5@https.bugzilla.kernel.org/>
References: <bug-198111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34698 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbdLIR6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2017 12:58:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BB7302910A
        for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2017 17:58:05 +0000 (UTC)
In-Reply-To: <bug-198111-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198111

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #2 from Bart Van Assche (bvanassche@acm.org) ---
The kernel version shown in the bug report is 4.14.3-1.el6.elrepo.x86_64. Does
that mean that your kernel comes from http://elrepo.org/? This bug tracker is
intended for kernel versions downloaded from https://www.kernel.org/. Please
report this bug to the organization that provided kernel version
4.14.3-1.el6.elrepo.x86_64.

-- 
You are receiving this mail because:
You are the assignee for the bug.
