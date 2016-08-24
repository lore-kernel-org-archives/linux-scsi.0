From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Wed, 24 Aug 2016 12:33:37 +0000
Message-ID: <bug-153171-11613-qLFDBxWi94@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbcHXMdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Aug 2016 08:33:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 5B74B2038A
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 12:33:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 49E5920384
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 12:33:37 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

Chris Bainbridge <chris.bainbridge@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chris.bainbridge@gmail.com

--- Comment #3 from Chris Bainbridge <chris.bainbridge@gmail.com> ---
Error message present in 4.8.0-rc3
Error message disappears after applying fix
https://patchwork.kernel.org/patch/9262149/ 
Would be good to merge the fix before 4.9.0 is released

-- 
You are receiving this mail because:
You are the assignee for the bug.
