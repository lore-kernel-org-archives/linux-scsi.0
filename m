From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Sun, 02 Oct 2016 18:27:23 +0000
Message-ID: <bug-153171-11613-hKfcxRuBeO@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbcJBS11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 2 Oct 2016 14:27:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B2B952025A
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 18:27:25 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 6115B20219
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 18:27:23 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

Christian Stadelmann <dev@genodeftest.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dev@genodeftest.de

--- Comment #6 from Christian Stadelmann <dev@genodeftest.de> ---
I'm seeing the same dmesg output too, on 2 machines with 4.8.0 rc7 / rc8
kernels.

It seems like this bug is preventing me on these machines to use any USB thumb
drives at all. In case anyone can confirm this I think it should go into 4.8.0
before release immediately.

-- 
You are receiving this mail because:
You are the assignee for the bug.
