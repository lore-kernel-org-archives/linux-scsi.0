From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188961] Function mvs_task_prep() returns improper values on
 failures
Date: Fri, 12 May 2017 00:20:09 +0000
Message-ID: <bug-188961-11613-JhdFa88yCo@https.bugzilla.kernel.org/>
References: <bug-188961-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49702 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753367AbdELAUY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 20:20:24 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D72BC28798
        for <linux-scsi@vger.kernel.org>; Fri, 12 May 2017 00:20:23 +0000 (UTC)
In-Reply-To: <bug-188961-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188961

bianpan (bianpan2010@ruc.edu.cn) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #1 from bianpan (bianpan2010@ruc.edu.cn) ---
Fixed in linux-v4.11. So I will close the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
