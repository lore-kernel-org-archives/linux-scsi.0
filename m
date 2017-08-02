From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196543] Adaptec 6405H can not understand Queue full message
 from Disks.
Date: Wed, 02 Aug 2017 08:14:03 +0000
Message-ID: <bug-196543-11613-zs5k6S4x3q@https.bugzilla.kernel.org/>
References: <bug-196543-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56986 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751295AbdHBIOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 04:14:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0C43428799
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2017 08:14:11 +0000 (UTC)
In-Reply-To: <bug-196543-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196543

Jack Wang (xjtuwjp@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xjtuwjp@gmail.com

--- Comment #3 from Jack Wang (xjtuwjp@gmail.com) ---
Hi Kazufumi,

Could you send out dmesg with logging_level=0xfff for scsi_host on microsemi
HBA when queue full condition happens?

-- 
You are receiving this mail because:
You are the assignee for the bug.
