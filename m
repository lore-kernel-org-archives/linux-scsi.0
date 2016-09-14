From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Wed, 14 Sep 2016 10:20:35 +0000
Message-ID: <bug-151661-11613-CPUNR1rPou@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761344AbcINKUk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 06:20:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4FD93204A7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:20:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 820692049D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 10:20:35 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #15 from HE - IT Services <he001@fitmsg.net> ---
(In reply to HE - IT Services from comment #13)
> I have the exact same problem on Proxmox which is using Debian Jesse Linux
> Kernel 4.2.4, using Adaptec Raid 31605, it repeats every 10 seconds, "AAC:
> Host adapter dead -1" but everything is working......
> 
> Is there any way to get it to stop repeating these messages, because it may
> max out the messages log eventually.  Does anyone know what is being done to
> patch this?

I found the Kernel is 4.4.13-2-pve, which would be 4.4.13.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
