From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Thu, 07 Dec 2017 21:40:24 +0000
Message-ID: <bug-197875-11613-yo5QjMgF0z@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50392 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750947AbdLGVkd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 16:40:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A901B28880
        for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2017 21:40:32 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #9 from Bart Van Assche (bvanassche@acm.org) ---
My hope was that the list of PCI devices would show a PCI HBA of which the
driver has been modified recently. Since that's not the case I'm out of ideas
about what could be the root cause of this bug. Unless someone else has an idea
about how to find the root cause of this issue I think your only option is to
perform a bisect of the Linux kernel.

-- 
You are receiving this mail because:
You are the assignee for the bug.
