From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Fri, 02 Dec 2016 21:11:17 +0000
Message-ID: <bug-176951-11613-i5b0dS219F@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbcLBVLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 16:11:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 41A9A203C2
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2016 21:11:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 7A607203DC
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2016 21:11:17 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

mus.svz@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mus.svz@gmail.com

--- Comment #6 from mus.svz@gmail.com ---
I can confirm this issue on my Acer Swift 3 Model SF314-51-59RF. Arch Linux x64
with kernel 4.8.11 and 4.9.rc7 hang with a black screen on boot.

However, I can also confirm some reports from this acer thread that this seems
to be a x64 specific issue:

https://community.acer.com/t5/Swift-Spin-S-and-R-Series/Ubuntu-on-Swift-3-SF314-51-74FW-black-screen-after-menu-on-Live/td-p/464481/highlight/true/page/3

I'm typing this from a perfectly fine working Fedora 25 32-Bit Live system with
kernel 4.8.6. The x64 version hangs on boot just like Arch Linux.

btw, there is no BIOS update available for the Swift 3 yet (BIOS version 1.05).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
