From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115351] New: redundant pointless messages
Date: Sun, 27 Mar 2016 19:48:58 +0000
Message-ID: <bug-115351-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59860 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbcC0TtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2016 15:49:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7937F2024C
	for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2016 19:48:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 71A2B2021F
	for <linux-scsi@vger.kernel.org>; Sun, 27 Mar 2016 19:48:58 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=115351

            Bug ID: 115351
           Summary: redundant pointless messages
           Product: IO/Storage
           Version: 2.5
    Kernel Version: All
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: spamme@ecybernard.com
        Regression: No

First, why does it have to log "Very big device" 44 times on startup.
Second, Given the size of ALL modern hard drives an array of almost any size
probably triggers this warning.  

Suggestion:  just get rid of this pointless message.  Maybe you should just
always use 16, or maybe for future proofing go to 24 or 32. 

[    2.518621] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[    2.521082] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[    2.530614] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   31.160167] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   31.162414] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   39.091369] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   39.093872] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   45.880219] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   48.171378] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   54.069779] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   54.074579] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   54.077133] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   77.748461] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   77.759371] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   84.549201] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[   91.288396] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  104.879051] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  104.881052] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  118.411278] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  125.193326] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  125.194891] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  159.063910] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  159.067481] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  179.361285] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  179.364259] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  179.379481] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  199.666114] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  213.116560] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  213.118659] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  213.120798] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  213.123825] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  213.125164] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  233.471647] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  233.473467] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  251.053596] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  251.055879] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  251.057935] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  251.059881] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  257.699835] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  278.193261] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  326.820650] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  326.852786] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[  346.504500] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[ 1233.124007] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).

-- 
You are receiving this mail because:
You are the assignee for the bug.
