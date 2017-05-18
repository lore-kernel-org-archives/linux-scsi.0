From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Thu, 18 May 2017 18:09:51 +0000
Message-ID: <bug-195285-11613-AIL0lrzhj8@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34758 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752920AbdERSJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 14:09:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0F6B62887D
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 18:09:53 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #6 from himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) ---
Hi Anthony, Laurence, 

Can you try attached patch to see if it works for you? 

if Yes, I'll send out to SCSI mailing list to be included into upstream. 

Thanks,
Himanshu

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
