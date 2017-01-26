From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Thu, 26 Jan 2017 08:15:21 +0000
Message-ID: <bug-176951-11613-4h6Uk5EL8U@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752886AbdAZIPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 03:15:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 49ADA20497
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 08:15:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 1109E20480
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 08:15:23 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #19 from Dmitry Sysoletin <dmitry.sysoletin@gmail.com> ---
(In reply to Zhang Rui from comment #11)
> please check if the latest upstream kernel works for you or not.
> If yes, I will close this bug as the original bug has been fixed by BIOS
> upgrade, and the arch linux 4.9 kernel issue sounds like a Distro problem to
> me.

I'am checked 4.10.0-rc5, and have about one successful reboot for 10 reboot
attempts. I have 2 different types of fail - most often it happens about at 0.5
second uptime, but I catched another failure on ~24 second (screenshots
attached).
System is 64-bit, booting with legacy mode, BIOS updated to 1.07 (it seems like
switching legacy <-> UEFI don't make sense). Sometimes I able to boot, if I
press F2 at power-up moment, enter EFI-shell, press ctrl+alt+del - seems like
this increasing boot chances.
I tried with acpi=ht also, but this don't changes behaviour.


I'am able to boot ubuntu with 4.2 kernel from liveusb - and I see messages that
some people able to run other distros. That distros use vanilla kernel, or have
some patches? I guess ubuntu not using vanilla kernel - there must be some
patches fixing/masking this issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
