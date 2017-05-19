From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Fri, 19 May 2017 16:11:42 +0000
Message-ID: <bug-195285-11613-kMe7aC1ogO@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59042 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbdESQUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 12:20:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BC5DC27F86
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2017 16:20:42 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #10 from himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) ---
Hi Anthony, 
(In reply to Anthony from comment #9)
> patch work fine on 4.12.0-0.rc1 with ql2xmqsupport enabled

Thanks for validation. I'll send this patch to scsi tree with proper tags. 

-Himanshu

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
