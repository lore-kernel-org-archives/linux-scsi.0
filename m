From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Wed, 22 Mar 2017 15:37:34 +0000
Message-ID: <bug-176951-11613-VRUCpj1iJB@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33636 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934947AbdCVPiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 11:38:13 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B7E5E2845C
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2017 15:37:37 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EFD942845C
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2017 15:37:34 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

Alan Welsh (itsallenergy@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |itsallenergy@gmail.com

--- Comment #22 from Alan Welsh (itsallenergy@gmail.com) ---
I can confirm the system does not boot unless either: a) passed with the
acpi=off parameter in legacy mode or, b) booted in UEFI mode.

As for (a): This issue is resolved with grsecurity kernel.

As for (b): UEFI cannot be used because all linux bootloaders fail to be
recognized by the firmware. There is not one distribution which boots after
installation. The bootloader never loads. Only receive error message "disk not
found" or something to that effect.

Acer swift 3 (bios 1.08)

All x64 flavors from: Ubuntu, Fedora, Gentoo, Arch, opensuse.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
