From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] Adaptec ICP9087MA: aacraid prints "AAC: Host adapter is
 dead (or got a PCI error) -1" twice times around errors of aacraid and the
 kernel crashes after starting the "Kernel Device Manager"
Date: Fri, 25 Aug 2017 22:05:47 +0000
Message-ID: <bug-196707-11613-ApfaVHgERT@https.bugzilla.kernel.org/>
References: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39386 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932623AbdHYWFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 18:05:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A351328543
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 22:05:48 +0000 (UTC)
In-Reply-To: <bug-196707-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

Andreas Gerlich (kernel.org@yaze-ag.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|4.12.8                      |4.12.9

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
