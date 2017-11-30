From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Thu, 30 Nov 2017 16:04:40 +0000
Message-ID: <bug-197875-11613-G9C2GhnCnS@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57188 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752259AbdK3QEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Nov 2017 11:04:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 55B902A1D7
        for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2017 16:04:41 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #8 from Chuck Burt (chuck.burt+kernel.org@gmail.com) ---
Created attachment 260953
  --> https://bugzilla.kernel.org/attachment.cgi?id=260953&action=edit
Output of lspci on 4.10.x kernel

I won't be able to boot into the newer kernel for about a week, however since
`lspci` is hardware-oriented, sharing the output under the older kernel in case
it's helpful.  Please let me know if you want me to run it on the new one
instead and I'll get it when I can.

-- 
You are receiving this mail because:
You are the assignee for the bug.
