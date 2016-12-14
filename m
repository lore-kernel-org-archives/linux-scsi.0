From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Wed, 14 Dec 2016 17:48:06 +0000
Message-ID: <bug-176951-11613-bByChPqiNo@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751713AbcLNRsM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Dec 2016 12:48:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 1E351203F3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 17:48:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 3A0F520439
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 17:48:07 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #7 from mus.svz@gmail.com ---
Update:

It seems like this was partly fixed by BIOS upgrade 1.07 (only available via
Windows Update).

Fedora x64 and Ubuntu x64 are confirmed to boot after the BIOS upgrade (see the
mentioned acer community thread).

However, Arch Linux x64 still doesn't boot and I haven't figured out the
difference yet. Arch has kernel 4.8.11 while Fedora boots fine with 4.8.6 and
4.8.13, so I doubt it's the kernel version.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
