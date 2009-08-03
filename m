From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13873] QLA2xxx driver causes kernel oops with a qla2200
Date: Mon, 3 Aug 2009 02:37:00 GMT
Message-ID: <200908030237.n732b0hn029983@demeter.kernel.org>
References: <bug-13873-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35864 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZHCChA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2009 22:37:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n732b0m8029984
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 02:37:00 GMT
In-Reply-To: <bug-13873-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13873





--- Comment #4 from Thomas <tageorgiou@gmail.com>  2009-08-03 02:37:00 ---
The same io hanging just happened again, but this time, no calltrace was
printed.  It appears the HBA (qla2200) is crashing?
[  925.960038] qla2xxx 0000:06:02.0: scsi(0:41:0): Abort command issued -- 1
80c 2002.                                                        
[  936.970054] qla2xxx 0000:06:02.0: scsi(0:41:0): Abort command issued -- 1
80c 2002.                                                        
[  936.970109] qla2xxx 0000:06:02.0: scsi(0:41:0): DEVICE RESET ISSUED.         
[  936.970197] qla2xxx 0000:06:02.0: scsi(0:41:0): DEVICE RESET SUCCEEDED.      
[  947.980052] qla2xxx 0000:06:02.0: scsi(0:41:0): Abort command issued -- 1
80c 2002.
[  947.980061] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET ISSUED.
[  947.980923] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET SUCCEEDED.
[  947.980935] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET ISSUED.
[  947.981039] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET SUCCEEDED.
[  947.981059] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET ISSUED.
[  977.980056] qla2xxx 0000:06:02.0: Mailbox command timeout occurred. Issuing
ISP abort.
[  977.980064] qla2xxx 0000:06:02.0: Performing ISP error recovery - ha=
ffff88019a657800.
[  978.980036]  rport-0:0-0: blocked FC remote port time out: removing target
and saving binding
[ 1008.060024] qla2xxx 0000:06:02.0: Failed mailbox send register test
[ 1008.060031] qla2xxx 0000:06:02.0: qla2x00_abort_isp: **** FAILED ****
[ 1008.060042] qla2xxx 0000:06:02.0: scsi(0:41:0): TARGET RESET FAILED: Task
management failed.
[ 1008.080761]  rport-0:0-1: blocked FC remote port time out: removing target
and saving binding
[ 1038.080082]  rport-0:0-2: blocked FC remote port time out: removing target
and saving binding
[ 1038.081903] qla2xxx 0000:06:02.0: Mailbox command timeout occurred. Issuing
ISP abort.
[ 1038.081909] qla2xxx 0000:06:02.0: Performing ISP error recovery - ha=
ffff88019a657800.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
