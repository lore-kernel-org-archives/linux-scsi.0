From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sun, 04 Dec 2016 20:26:32 +0000
Message-ID: <bug-151631-11613-iPRZEaFJJo@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDU0i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Dec 2016 15:26:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D5912202B8
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2016 20:26:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 0EC3220263
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2016 20:26:33 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

--- Comment #8 from Daniele Viganò <dennyvatwork@gmail.com> ---
@Rich, have a look at https://bugzilla.kernel.org/show_bug.cgi?id=187061

Bug has been resolved it 4.9-rc7.

-- 
You are receiving this mail because:
You are the assignee for the bug.