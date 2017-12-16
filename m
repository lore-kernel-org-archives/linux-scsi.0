From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198161] incremental patch-4.9.51-52 on sg.c break Nero 4 nero
 burning rom application
Date: Sat, 16 Dec 2017 14:02:21 +0000
Message-ID: <bug-198161-11613-VKiUSHDhzt@https.bugzilla.kernel.org/>
References: <bug-198161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45266 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756846AbdLPOCY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Dec 2017 09:02:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B000D29DFC
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2017 14:02:23 +0000 (UTC)
In-Reply-To: <bug-198161-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198161

--- Comment #3 from Jean-Luc (luc.bertho@gmail.com) ---
(In reply to Johannes Thumshirn from comment #2)
> (In reply to Jean-Luc from comment #0)
> > Hi
> > 
> > Nero 4 Linux can no longer detect devices since the changes in code in
> sg.c.
> > It displays the following message: "Warning: no device detected"...
> > 
> > Regards
> 
> Can you please re-test with a more recent kernel (e.g. v4.14) ? I have had
> submitted a fix for exactly this issue with Nero and believe it is gone.

Hello Johannes,
the only versions of the kernel that seem impacted are kernel 4.9.52-> 4.9.69
I saw your fix for the kernel version 4.12 and I checked it successfully with a
4.12.1 kernel
the latest version of the kernel is not affected by this bug.

Versions tested and OK: 
4.12.1 (with your patch)
4.13.1
4.14.5

I also try kernel 4.10.0-42-generic
(VirtualBox, Ubuntu), ok too

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
