From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198161] incremental patch-4.9.51-52 on sg.c break Nero 4 nero
 burning rom application
Date: Thu, 14 Dec 2017 05:14:18 +0000
Message-ID: <bug-198161-11613-gVsBj2jx6c@https.bugzilla.kernel.org/>
References: <bug-198161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752090AbdLNFOT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 00:14:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CC79929B4B
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2017 05:14:18 +0000 (UTC)
In-Reply-To: <bug-198161-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198161

Bart Van Assche (bvanassche@acm.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bvanassche@acm.org

--- Comment #1 from Bart Van Assche (bvanassche@acm.org) ---
That's really bad. We need to know whether this issue only occurs with older
stable kernels or also in recent kernel versions. Please verify with a recent
kernel version. If I e.g. install nerolinux-4.0.0.0b-x86_64.deb in a VM running
kernel 4.13.0-19-generic then it correctly recognizes the Qemu DVD.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
