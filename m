From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Dec 2016 11:15:18 +0000
Message-ID: <bug-60644-11613-oZokFhIjWG@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbcL1LPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Dec 2016 06:15:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 6017220519
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 11:15:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id A795C204D8
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 11:15:21 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

ojab@ojab.ru changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ojab@ojab.ru

--- Comment #50 from ojab@ojab.ru ---
Created attachment 248831
  --> https://bugzilla.kernel.org/attachment.cgi?id=248831&action=edit
Possible fix

This patch disables ASPM powersave for controller's pci link.
I can't reproduce the isse with ASPM enabled and this patch applied (4.9
kernel, LSI SAS 9217-8i HBA), but more testing will not hurt.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
