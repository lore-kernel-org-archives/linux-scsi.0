From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188941] Function beiscsi_create_cqs() may return improper value
 when the call to pci_alloc_consistent() fails, which may result in
 use-after-free
Date: Fri, 12 May 2017 00:14:31 +0000
Message-ID: <bug-188941-11613-zJeoQQySlc@https.bugzilla.kernel.org/>
References: <bug-188941-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49202 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756730AbdELAOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 May 2017 20:14:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B5EFF28783
        for <linux-scsi@vger.kernel.org>; Fri, 12 May 2017 00:14:32 +0000 (UTC)
In-Reply-To: <bug-188941-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188941

bianpan (bianpan2010@ruc.edu.cn) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
