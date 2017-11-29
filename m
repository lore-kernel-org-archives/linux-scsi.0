From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Wed, 29 Nov 2017 14:14:44 +0000
Message-ID: <bug-197875-11613-68wwGLOvBT@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54028 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752822AbdK2OOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 09:14:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9CDE3298F1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 14:14:44 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #3 from Chuck Burt (chuck.burt+kernel.org@gmail.com) ---
Created attachment 260927
  --> https://bugzilla.kernel.org/attachment.cgi?id=260927&action=edit
Output of requested command as su

After reading the first few lines of the last attachment, it occurred to me
that running this command as su might be useful.  See attached.

-- 
You are receiving this mail because:
You are the assignee for the bug.
