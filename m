From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Mon, 26 Dec 2016 01:53:46 +0000
Message-ID: <bug-176951-11613-xoTmGiBtwz@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754587AbcLZBxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Dec 2016 20:53:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 45B2F20454
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 01:53:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 740F62043C
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 01:53:46 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #11 from Zhang Rui <rui.zhang@intel.com> ---
please check if the latest upstream kernel works for you or not.
If yes, I will close this bug as the original bug has been fixed by BIOS
upgrade, and the arch linux 4.9 kernel issue sounds like a Distro problem to
me.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
