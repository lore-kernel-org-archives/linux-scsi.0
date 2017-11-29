From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197875] Processes hang on attempted access of WDC WD30-EZRX 3TB
 HDD on HP Z420 Workstation
Date: Wed, 29 Nov 2017 14:07:59 +0000
Message-ID: <bug-197875-11613-aup3ykQ2UJ@https.bugzilla.kernel.org/>
References: <bug-197875-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49664 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752182AbdK2OIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 09:08:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3F829298AD
        for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2017 14:08:00 +0000 (UTC)
In-Reply-To: <bug-197875-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197875

--- Comment #2 from Chuck Burt (chuck.burt+kernel.org@gmail.com) ---
Created attachment 260925
  --> https://bugzilla.kernel.org/attachment.cgi?id=260925&action=edit
Output of requested command

I reproduced the hang and ran the command as requested.  See attached file
output-20171129.txt

Building the kernel is something I could attempt tackling, but as a newbie I'm
highly likely to mess something up.  Either way, it will be a few weeks before
I can get to it (best case).  So I _really_ hope this provides the clue needed!

-- 
You are receiving this mail because:
You are the assignee for the bug.
