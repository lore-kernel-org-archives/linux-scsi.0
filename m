From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Thu, 10 Nov 2016 06:54:16 +0000
Message-ID: <bug-151631-11613-3DojSRBBNH@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752621AbcKJGyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 01:54:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id CD8C1203B6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 06:54:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id E8FFF203B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 06:54:16 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

Daniele Viganò <dennyvatwork@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dennyvatwork@gmail.com

--- Comment #6 from Daniele Viganò <dennyvatwork@gmail.com> ---
I can confirm exactly the same bug on my Dell Latitude E5450 with an SSD
(Samsung 840) running Fedora 24 and kernel 4.8.6 (4.7.9 was fine).

The patch provided by Gianpaolo solved the issue on my machine.

-- 
You are receiving this mail because:
You are the assignee for the bug.