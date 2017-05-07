From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Sun, 07 May 2017 10:19:57 +0000
Message-ID: <bug-176951-11613-TxjcMgmK1A@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47762 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756275AbdEGWHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2017 18:07:08 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AA91628481
        for <linux-scsi@vger.kernel.org>; Sun,  7 May 2017 10:20:01 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #25 from Alberto Tiboni (a.tiboni@gmail.com) ---
(In reply to Alberto Tiboni from comment #24)
> I can confirm issue is still here: update bios at 1.08, nothing changed!
> 
> Tried Ubuntu and Lubuntu distro, 16.04, 16.10 and 17.04, both 64 and 32bits.
> 
> The only one that booted after installation was Lubuntu 16.04 32bit in
> legacy mode, with grub without "quite splash" parameters.
> 
> but it works rarely: 9 on 10 times it produces a kernel panic on apci init.
> 
> Now I'm trying linux Mint, but i'm quite sure problem will be there too.



Hi there, found this
https://www.reddit.com/r/linuxmint/comments/5lu69k/installing_linux_mint_181_on_an_acer_swift_3/

don't know if can help, but at second install attempt the system is stable with
kernel 4.4.0-53-generic

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
