From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Wed, 03 May 2017 05:59:26 +0000
Message-ID: <bug-176951-11613-GSkBwMelDw@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44384 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751010AbdECF72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 01:59:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 10EF9285F1
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2017 05:59:27 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

Max (700ghz@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |700ghz@gmail.com

--- Comment #23 from Max (700ghz@gmail.com) ---
I can confirm the bug on my Acer Swift 3 Model SF314-51 (bios 1.08).
I able to install just Mint 18.1. I found that it freezes when:
1. ~4 times of 5 when my machine start ups (boot logo/black screen); 
2. usually when chrome starts; 
3. when brightness changes very fast; 
4. when shut down.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
