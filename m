From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101841] iommu memory handling cause mmblock devices stop
 working
Date: Sat, 27 Aug 2016 09:25:49 +0000
Message-ID: <bug-101841-11613-9zNMtW45DZ@https.bugzilla.kernel.org/>
References: <bug-101841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752533AbcH0JgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Aug 2016 05:36:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C9F9D20384
        for <linux-scsi@vger.kernel.org>; Sat, 27 Aug 2016 09:25:50 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id CAD1F20376
        for <linux-scsi@vger.kernel.org>; Sat, 27 Aug 2016 09:25:49 +0000 (UTC)
In-Reply-To: <bug-101841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101841

--- Comment #3 from Ivan <dront78@gmail.com> ---
fixed with modprobe
options jmb38x_ms no_dma=Y
JMicron Technology Corp. MS Host Controller (rev 20) 197b:2383

-- 
You are receiving this mail because:
You are the assignee for the bug.
