From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] Adaptec ICP9087MA: aacraid prints "AAC: Host adapter is
 dead (or got a PCI error) -1" twice times around errors of aacraid and the
 kernel crashes after starting the "Kernel Device Manager"
Date: Fri, 18 Aug 2017 23:01:26 +0000
Message-ID: <bug-196707-11613-32FHQgOAUk@https.bugzilla.kernel.org/>
References: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48524 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751243AbdHRXBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 19:01:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0767B28D96
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 23:01:41 +0000 (UTC)
In-Reply-To: <bug-196707-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

--- Comment #2 from Andreas Gerlich (kernel.org@yaze-ag.de) ---
Created attachment 258017
  --> https://bugzilla.kernel.org/attachment.cgi?id=258017&action=edit
Kernel_output_after_patch_from_Dave_Carroll.cap

Hello Dave Carroll,

I apply the patch and put the output of the kernel start (4.12.8) as a
attachment.

The Kernel crashes again at the "Kernel Device Manager" after errors from the
aacraid.

Best Regards
Andreas Gerlich

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
