From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Wed, 14 Sep 2016 17:03:19 +0000
Message-ID: <bug-153171-11613-COD576qSVn@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755877AbcINRDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 13:03:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 850942045A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 17:03:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 7A62520444
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2016 17:03:19 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

Martin K. Petersen <mkp@mkp.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net

--- Comment #5 from Martin K. Petersen <mkp@mkp.net> ---
I would like the change to get a bit of soak time before we backport it.

-- 
You are receiving this mail because:
You are the assignee for the bug.
