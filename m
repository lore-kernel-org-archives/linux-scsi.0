From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Mon, 08 Jan 2018 17:44:21 +0000
Message-ID: <bug-151661-11613-VERdpUaeOt@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50206 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751843AbeAHRoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 12:44:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B63AE2892E
        for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2018 17:44:21 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #22 from Matthias (hm10439@gmail.com) ---
with my Adaptec 3405 and Kernel of Ubuntu 16.04.3 (Kernel 4.4.0-104-generic)
and also with self-compiled 4.13.0, the message does not appear anymore.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
