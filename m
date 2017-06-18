From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Sun, 18 Jun 2017 10:20:20 +0000
Message-ID: <bug-176951-11613-JJqQ5aQYlf@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49290 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751009AbdFRKUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jun 2017 06:20:22 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EFDD5284A4
        for <linux-scsi@vger.kernel.org>; Sun, 18 Jun 2017 10:20:21 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

--- Comment #26 from Alan Welsh (itsallenergy@gmail.com) ---
[Arch system, Legacy mode, 64 bit]

Can now boot with the "mainline" kernel [4.12.0-rc5-mainline] as well as the
"hardened" kernel [4.11.6.a-1]. The latter is purposed as a replacement for the
grsecurity kernel.

Does this mean we can expect a working kernel for our machines from the various
distributions in the near future?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
