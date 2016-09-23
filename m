From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172831] Adaptec ASR7805 in RAID (Expose RAW) mode recreate
 block devices and broke MDRAID
Date: Fri, 23 Sep 2016 23:51:12 +0000
Message-ID: <bug-172831-11613-F3qbwwUipx@https.bugzilla.kernel.org/>
References: <bug-172831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760052AbcIWXvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Sep 2016 19:51:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8038F2043C
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:51:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 99A3A203F3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:51:12 +0000 (UTC)
In-Reply-To: <bug-172831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=172831

--- Comment #8 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
Created attachment 239591
  --> https://bugzilla.kernel.org/attachment.cgi?id=239591&action=edit
rpm -qa

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
