From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Thu, 04 May 2017 11:07:42 +0000
Message-ID: <bug-176951-11613-k4GQauztJn@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56932 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751907AbdEDLHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2017 07:07:44 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8B2742869D
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2017 11:07:43 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

Alberto Tiboni (a.tiboni@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |a.tiboni@gmail.com

--- Comment #24 from Alberto Tiboni (a.tiboni@gmail.com) ---
I can confirm issue is still here: update bios at 1.08, nothing changed!

Tried Ubuntu and Lubuntu distro, 16.04, 16.10 and 17.04, both 64 and 32bits.

The only one that booted after installation was Lubuntu 16.04 32bit in legacy
mode, with grub without "quite splash" parameters.

but it works rarely: 9 on 10 times it produces a kernel panic on apci init.

Now I'm trying linux Mint, but i'm quite sure problem will be there too.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
