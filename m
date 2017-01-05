From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Thu, 05 Jan 2017 19:37:55 +0000
Message-ID: <bug-176951-11613-RJGsNdq6Ca@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754555AbdAETiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Jan 2017 14:38:00 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0B81F205E1
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2017 19:37:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 0848D205D3
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2017 19:37:56 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #16 from mus.svz@gmail.com ---
Created attachment 250411
  --> https://bugzilla.kernel.org/attachment.cgi?id=250411&action=edit
dmesg with ACPI errors (kernel 4.10rc2)

Bisecting this is really frustrating because it randomly works in different
combinations, depending on whether UEFI or Legacy boot is enabled in BIOS and
whether you boot via USB or SSD and sometimes pure chance...

The good(?) news is: kernel 4.10rc2 boots in almost all circumstances. But the
only combination that is actually stable is the same one that already works
with 4.8 and 4.9: booting with legacy mode enabled from the internal SSD.

When I boot 4.10rc2 with UEFI mode enabled in BIOS or via USB, the system
doesn't hang like with previous kernels. Instead I get quite a few ACPI errors
and the system manages to boot completely most of the time, but freezes
completely after a few seconds.

The full dmesg is attached. This is with UEFI mode enabled in BIOS and booting
4.10rc2 from the internal SSD. Hopefully the ACPI warnings and errors help
narrow this down...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
