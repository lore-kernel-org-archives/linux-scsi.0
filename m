From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Sat, 31 Dec 2016 04:27:21 +0000
Message-ID: <bug-176951-11613-KCQgM4Rew2@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754554AbcLaE10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Dec 2016 23:27:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id DB58C2058E
        for <linux-scsi@vger.kernel.org>; Sat, 31 Dec 2016 04:27:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 8DCC420588
        for <linux-scsi@vger.kernel.org>; Sat, 31 Dec 2016 04:27:21 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #14 from matteo.terruzzi@gmail.com ---
I now report complete functionality and stability with kernel linux-grsec
4.8.15.r201612151923-1 from Arch Linux community repository.

Also, in order to fix a different problem, I have always put in mkinitcpio.conf
the following: MODULES="crc32_generic crc32-pclmul libcrc32c crc32c_generic
crc32c-intel"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
