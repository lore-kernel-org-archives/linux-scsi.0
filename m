From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198111] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
 [swapper/0:0] [libahci]
Date: Sat, 09 Dec 2017 18:01:22 +0000
Message-ID: <bug-198111-11613-AHpN7Nxoag@https.bugzilla.kernel.org/>
References: <bug-198111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34958 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750954AbdLISBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2017 13:01:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 66556290D8
        for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2017 18:01:24 +0000 (UTC)
In-Reply-To: <bug-198111-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198111

--- Comment #3 from SviMik (svimik@gmail.com) ---
According to [1], "If a bug is found when using these kernels, the end user is
encouraged to report it upstream to the Linux Kernel Bug Tracker"

[1] http://elrepo.org/tiki/kernel-ml

-- 
You are receiving this mail because:
You are the assignee for the bug.
