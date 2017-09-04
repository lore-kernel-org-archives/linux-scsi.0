From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196707] Adaptec ICP9087MA: aacraid prints "AAC: Host adapter is
 dead (or got a PCI error) -1" twice times around errors of aacraid and the
 kernel crashes after starting the "Kernel Device Manager"
Date: Mon, 04 Sep 2017 21:04:34 +0000
Message-ID: <bug-196707-11613-SFXUceGuzo@https.bugzilla.kernel.org/>
References: <bug-196707-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40658 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751329AbdIDVEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2017 17:04:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E05592874B
        for <linux-scsi@vger.kernel.org>; Mon,  4 Sep 2017 21:04:42 +0000 (UTC)
In-Reply-To: <bug-196707-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=196707

--- Comment #4 from Andreas Gerlich (kernel.org@yaze-ag.de) ---
Created attachment 258209
  --> https://bugzilla.kernel.org/attachment.cgi?id=258209&action=edit
Kernel_crash_(4.13.0)_with_4_drives_at_the_ICP9087MA

Hi,

i tried the actual Kernel 4.13.0.
It crashes after errors of aacraid.
I put the output of the kernel start as a attachment.

- Andreas Gerlich

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
You are watching someone on the CC list of the bug.
