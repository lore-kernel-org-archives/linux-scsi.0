From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Thu, 22 Dec 2016 20:30:33 +0000
Message-ID: <bug-176951-11613-wHa3ksBqqp@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbcLVUah (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 15:30:37 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4FEAA203E3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2016 20:30:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 87541203C1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2016 20:30:34 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #10 from mus.svz@gmail.com ---
Created attachment 248381
  --> https://bugzilla.kernel.org/attachment.cgi?id=248381&action=edit
Kernel Panic Arch Linux x64 kernel 4.9

Attached is a kernel panic I get with Arch Linux x64 and kernel 4.9.
Unfortunately I can't get the whole stack trace. I tried to up the resolution
with the vga= parameter but then the screen stays black. I actually got it to
boot once, but had no other success after 10 other tries.

The stacktrace looks very similiar to Bug 58201 (comment 20 on this bug also
mentions the same problem with vga=).

Since Fedora and Ubuntu are fixed by the BIOS upgrade but Arch Linux still
doesn't boot, I guess this may be related to different kernel configs? Any
hints on which configs could affect this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
