From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Wed, 29 Nov 2017 20:01:10 +0000
Message-ID: <bug-197875-11613-b2ivnnVJlB@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45054 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752127AbdK2UBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 15:01:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A8C3E29BAF
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 20:01:10 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #6 from Chuck Burt (chuck.burt+kernel.org@gmail.com) ---
> # for d in /sys/block/*; do sfx=""; [ -e "$d/mq" ] && sfx=" [mq]"; echo
> "$d$sfx"; done
> /sys/block/loop0 [mq]
> /sys/block/loop1 [mq]
> /sys/block/loop2 [mq]
> /sys/block/loop3 [mq]
> /sys/block/loop4 [mq]
> /sys/block/loop5 [mq]
> /sys/block/loop6 [mq]
> /sys/block/loop7 [mq]
> /sys/block/sda
> /sys/block/sdb
> /sys/block/sdc
> /sys/block/sr0

-- 
You are receiving this mail because:
You are the assignee for the bug.
