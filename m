From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Tue, 25 Oct 2016 15:21:38 +0000
Message-ID: <bug-121531-11613-cb38I5CCxo@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754884AbcJYPVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 11:21:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D0EA72011D
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 15:21:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 0B36620218
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 15:21:39 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #17 from Chloé Desoutter <chloe@tigres-rouges.net> ---
Created attachment 242701
  --> https://bugzilla.kernel.org/attachment.cgi?id=242701&action=edit
pm8001_defs.h patch

PM8001_MPI_QUEUE: 1024 → 512 (more stable)

-- 
You are receiving this mail because:
You are the assignee for the bug.