From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] Adaptec ICP9087MA: aacraid prints "AAC: Host adapter is
 dead (or got a PCI error) -1" twice times around errors of aacraid and the
 kernel crashes after starting the "Kernel Device Manager"
Date: Fri, 18 Aug 2017 21:52:07 +0000
Message-ID: <bug-196707-11613-wbcqmBVgo7@https.bugzilla.kernel.org/>
References: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41790 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751807AbdHRVwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 17:52:08 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7336928D81
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 21:52:08 +0000 (UTC)
In-Reply-To: <bug-196707-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

Dave Carroll (david.carroll@microsemi.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |david.carroll@microsemi.com

--- Comment #1 from Dave Carroll (david.carroll@microsemi.com) ---
Created attachment 258015
  --> https://bugzilla.kernel.org/attachment.cgi?id=258015&action=edit
Patch to move pci check to pcie cards

Hi,

I've attached a patch based on Linus' current tree, but should apply to your
kernel. Can you try this patch, and report back.

Thanks, -Dave Carroll

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
