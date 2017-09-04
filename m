From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] Adaptec ICP9087MA: aacraid prints "AAC: Host adapter is
 dead (or got a PCI error) -1" twice times around errors of aacraid and the
 kernel crashes after starting the "Kernel Device Manager"
Date: Mon, 04 Sep 2017 21:05:34 +0000
Message-ID: <bug-196707-11613-r34gAO9SDa@https.bugzilla.kernel.org/>
References: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40806 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751329AbdIDVFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2017 17:05:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1E066287EF
        for <linux-scsi@vger.kernel.org>; Mon,  4 Sep 2017 21:05:36 +0000 (UTC)
In-Reply-To: <bug-196707-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

Andreas Gerlich (kernel.org@yaze-ag.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|4.12.9                      |4.13.0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
