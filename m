From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Thu, 27 Oct 2016 21:57:40 +0000
Message-ID: <bug-121531-11613-DCuzX8OeZM@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933375AbcJ0V5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 17:57:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 45716203A1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 21:57:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 1805020398
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2016 21:57:41 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #22 from Chloé Desoutter <chloe@tigres-rouges.net> ---
(In reply to Chloé Desoutter from comment #20)
> Currently testing w/ PM8001_MPI_QUEUE = 256.
> 
> Prospective patch attached.

I confirm that after 36 hours of intensive workload, I see no visible
performance loss on a PM8001 and that there's been no data error since then.

-- 
You are receiving this mail because:
You are the assignee for the bug.