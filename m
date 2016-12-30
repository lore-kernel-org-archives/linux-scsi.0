From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Fri, 30 Dec 2016 15:32:55 +0000
Message-ID: <bug-176951-11613-ATNyD7x73H@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752421AbcL3Pc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Dec 2016 10:32:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 09727205B7
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 15:32:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 130F62057F
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 15:32:56 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

matteo.terruzzi@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |matteo.terruzzi@gmail.com

--- Comment #13 from matteo.terruzzi@gmail.com ---
I'm reporting the same problem with Acer Travelmate X349-M, BIOS v1.07, 64bit
in all tests.

Also, I can get to the login prompt of gdm with everything working good
(including battery status, touchpad, wifi, special keys...) using Arch Linux
with replaced Kernel 4.10r1 from Ubuntu distribution and `acpi=force
acpi_osi='!Windows 2012'`,
but (unless acpi=off) it freezes on black screen just after successfull login
(the same with GNOME, GNOME Classic, GNOME Xorg).

Tried Kernel 4.0.9 from Ubuntu with acpi on, and it worked good for 10 minutes
on GNOME, but then stopped and didn't work at all for the following tries.
Tried Kernel 4.4.0: acpi=off, login ok; acpi on, crash with stack traces at
boot, behavior similar to 4.0.9.
Also note that Ubuntu 16.10 Live official image (linux-image-4.8.0-22-generic)
works perfectly.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
