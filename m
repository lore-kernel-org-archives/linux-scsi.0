From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21852] New: BUG: unable to handle kernel NULL pointer
 dereference at 0000000c (elv_quiesce_start)
Date: Tue, 2 Nov 2010 20:40:14 GMT
Message-ID: <bug-21852-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34559 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab0KBUkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 16:40:15 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA2KeE86002706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2010 20:40:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21852

           Summary: BUG: unable to handle kernel NULL pointer dereference
                    at 0000000c (elv_quiesce_start)
           Product: IO/Storage
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: maciej.rutecki@gmail.com
                CC: rjw@sisk.pl, maciej.rutecki@gmail.com,
                    fabio.comolli@gmail.com
        Regression: Yes


Subject    : BUG: unable to handle kernel NULL pointer dereference at 0000000c
(elv_quiesce_start)
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
Date       : 2010-10-23 17:39
Message-ID : AANLkTi=C4QpqAir0uf5tKbb_ZNo5BAuV3TAtY2mMu6bs@mail.gmail.com
References : http://marc.info/?l=linux-kernel&m=128785556619362&w=2

This entry is being used for tracking a regression from 2.6.36. Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
