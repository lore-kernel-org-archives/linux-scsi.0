From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Mon, 26 Dec 2016 01:54:39 +0000
Message-ID: <bug-176951-11613-SRmHN8Mmfi@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754587AbcLZByn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Dec 2016 20:54:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5598E20452
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 01:54:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 099FF20251
        for <linux-scsi@vger.kernel.org>; Mon, 26 Dec 2016 01:54:40 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #12 from Zhang Rui <rui.zhang@intel.com> ---
(In reply to Zhang Rui from comment #11)
> please check if the latest upstream kernel works for you or not.
> If yes, I will close this bug as the original bug has been fixed by BIOS
> upgrade, and the arch linux 4.9 kernel issue sounds like a Distro problem to
> me.
If no, please also check upstream 4.8 kernel to see if this is a upstream
kernel regression and use git bisect to find out the offending commit.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
