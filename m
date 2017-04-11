From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Tue, 11 Apr 2017 08:09:37 +0000
Message-ID: <bug-195285-11613-QRJmhAHjQX@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55744 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754138AbdDKIJ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 04:09:57 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C5FD9284C9
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 08:09:56 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9B158284C9
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 08:09:56 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #2 from Anthony (anthony.bloodoff@gmail.com) ---
All my test and and production environments a the same:
on tagret:
RAID controller (HP SmartArray / Adaptec 65xx)
BCache in writeback mode on Intel SSD NVME
QLE2564 in target mode

on initiator
QLE2562

optical patches 1 meter (MM) without FC switch

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
