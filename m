From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Fri, 19 May 2017 10:25:45 +0000
Message-ID: <bug-195285-11613-N5vNZJFAhR@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55096 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753010AbdESKZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 06:25:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3DCAB2889B
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2017 10:25:47 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #9 from Anthony (anthony.bloodoff@gmail.com) ---
patch work fine on 4.12.0-0.rc1 with ql2xmqsupport enabled

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
