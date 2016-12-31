From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Sat, 31 Dec 2016 11:59:27 +0000
Message-ID: <bug-176951-11613-RNo0V7EkRv@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752481AbcLaL7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Dec 2016 06:59:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5BFB6205BE
        for <linux-scsi@vger.kernel.org>; Sat, 31 Dec 2016 11:59:34 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id F280020225
        for <linux-scsi@vger.kernel.org>; Sat, 31 Dec 2016 11:59:27 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #15 from mus.svz@gmail.com ---
I just made an actual Arch Linux Installation instead of just trying to boot
the USB device - and on the installation everything works fine, including the
standard kernel (4.8.3 and 4.9.0) without any acpi parameters.

The kernel on my USB image and the installed kernel (both 4.8.3) even have the
same md5sum, but the USB one doesn't boot while the installed system works
fine. They also have the same bootloader (systemd-boot).

So for some reason this problem only happens on Arch Linux kernels and only
when booted via USB...!?

I'm gonna try the latest upstream kernel and bisect it...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
