From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188951] Function beiscsi_create_eqs() may return improper value
 when the call to pci_alloc_consistent() fails, which may result in
 use-after-free
Date: Fri, 12 May 2017 00:15:12 +0000
Message-ID: <bug-188951-11613-34dGNKhqpI@https.bugzilla.kernel.org/>
References: <bug-188951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49244 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756730AbdELAPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 20:15:13 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4584C28784
        for <linux-scsi@vger.kernel.org>; Fri, 12 May 2017 00:15:13 +0000 (UTC)
In-Reply-To: <bug-188951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188951

--- Comment #1 from bianpan (bianpan2010@ruc.edu.cn) ---
Created attachment 256441
  --> https://bugzilla.kernel.org/attachment.cgi?id=256441&action=edit
The patch fixes the bug

The patch has been merged into the latest version of the Linux kernel. So I
will close the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
