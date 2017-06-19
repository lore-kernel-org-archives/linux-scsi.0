From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Mon, 19 Jun 2017 19:13:59 +0000
Message-ID: <bug-176951-11613-f3aGg5akqy@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42488 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753211AbdFSTOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 15:14:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 98DF32847B
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 19:14:01 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #27 from mus.svz@gmail.com ---
Can confirm, this seems to be fixed in 4.12-rc5 mainline (Arch Linux x64).
Machine boots and works fine now, even in UEFI mode.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
