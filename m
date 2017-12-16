From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198161] incremental patch-4.9.51-52 on sg.c break Nero 4 nero
 burning rom application
Date: Sat, 16 Dec 2017 14:10:57 +0000
Message-ID: <bug-198161-11613-Dc7lXfKmqN@https.bugzilla.kernel.org/>
References: <bug-198161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45870 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752724AbdLPOK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Dec 2017 09:10:59 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 920A8295DC
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2017 14:10:59 +0000 (UTC)
In-Reply-To: <bug-198161-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198161

--- Comment #4 from Jean-Luc (luc.bertho@gmail.com) ---
(In reply to Bart Van Assche from comment #1)
> That's really bad. We need to know whether this issue only occurs with older
> stable kernels or also in recent kernel versions. Please verify with a
> recent kernel version. If I e.g. install nerolinux-4.0.0.0b-x86_64.deb in a
> VM running kernel 4.13.0-19-generic then it correctly recognizes the Qemu
> DVD.

Hello Bart,
I compiled and tested version 4.13.1 directly on my laptop
Operating System: Debian GNU / Linux 7.11
everything is OK

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
