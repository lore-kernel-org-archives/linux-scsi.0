From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Sat, 06 Jan 2018 16:02:42 +0000
Message-ID: <bug-151661-11613-BjxHbbps1k@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56460 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753376AbeAFQCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2018 11:02:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 60414289A8
        for <linux-scsi@vger.kernel.org>; Sat,  6 Jan 2018 16:02:44 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #21 from Rodrigo Aguilera (rodrigoaguileraparraga@gmail.com) ---
I stopped seeing this message after updating to debian stretch with the 4.9
kernel and my 3805 adaptec card.

I think this should be closed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
