From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172831] Adaptec ASR7805 in RAID (Expose RAW) mode recreate
 block devices and broke MDRAID
Date: Fri, 23 Sep 2016 23:49:55 +0000
Message-ID: <bug-172831-11613-O2nbQZfLgB@https.bugzilla.kernel.org/>
References: <bug-172831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757829AbcIWXt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Sep 2016 19:49:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 58D6F203C3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:49:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 56943203AD
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2016 23:49:55 +0000 (UTC)
In-Reply-To: <bug-172831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=172831

--- Comment #3 from Badalyan Vyacheslav <v.badalyan@open-bs.ru> ---
Created attachment 239541
  --> https://bugzilla.kernel.org/attachment.cgi?id=239541&action=edit
dmesg

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
