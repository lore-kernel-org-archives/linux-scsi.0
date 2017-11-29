From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Wed, 29 Nov 2017 20:16:11 +0000
Message-ID: <bug-197875-11613-8fkLE9fJsu@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50906 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751960AbdK2UQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 15:16:12 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B5DE29BCD
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 20:16:12 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #7 from Bart Van Assche (bvanassche@acm.org) ---
That's weird, there are no known queue lockup bugs in the legacy block/SCSI
core layers. Is the WDC harddisk perhaps controlled by a HBA? Can you provide
the output of lspci (run as root)?

-- 
You are receiving this mail because:
You are the assignee for the bug.
