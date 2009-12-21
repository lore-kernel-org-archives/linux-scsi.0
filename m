From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 21 Dec 2009 12:08:52 GMT
Message-ID: <200912211208.nBLC8qcn021167@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51731 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZLUMIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 07:08:52 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBLC8qUN021168
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 12:08:52 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #6 from Tim Small <tim@seoss.co.uk>  2009-12-21 12:08:50 ---
Hi Kashyap,

Thanks for your input.  Unfortunately, I can't test on the 1068, as the machine
is now in production (with SMART disabled!).

I do still have access to the 1068E and the 1064, and I will see if I can
borrow another 1068.

Could you try the attached script on your test system?  It carries out I/O to
the device which is under test, and seems to trigger failures much more quickly
as a result.

Thanks,

Tim.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
