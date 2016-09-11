From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Sun, 11 Sep 2016 11:43:06 +0000
Message-ID: <bug-153171-11613-wQSU06hnAZ@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752638AbcIKLnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Sep 2016 07:43:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4838020377
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2016 11:43:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 716ED20384
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2016 11:43:06 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

Thorsten Leemhuis <regressions@leemhuis.info> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |regressions@leemhuis.info

--- Comment #4 from Thorsten Leemhuis <regressions@leemhuis.info> ---
(In reply to Martin K. Petersen from comment #2)
> Severely lacking in the reviews department, though :(
Martin, the reporter considers this a regression, but according to
https://patchwork.kernel.org/patch/9262149/ you applied the fix to
4.9/scsi-queue – and it's not in mainline yet afaics. Was that an accident or
do you think this is not serious enough and thus better dealt with in 4.9?

-- 
You are receiving this mail because:
You are the assignee for the bug.