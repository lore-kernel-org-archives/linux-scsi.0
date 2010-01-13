From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 13 Jan 2010 12:30:50 GMT
Message-ID: <201001131230.o0DCUoHD001496@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41003 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0AMMav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 07:30:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0DCUok3001497
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2010 12:30:50 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #10 from Tim Small <tim@seoss.co.uk>  2010-01-13 12:30:47 ---
Hi Aaron,

It's possible that this is an unrelated issue.  On one of the systems with the
MPT SAS controllers, I have moved a drive from an MPT SAS channel onto an Intel
631xESB/632xESB SATA channel, and the unreliable behaviour appeared to stop.

Do you have any other drives which you can test in place of the WD drives? 
Personally I have found Hitachi SATA drives to be well engineered in recent
years from a SMART PoV.

If you'd like to open another bug, the script included in this bug might help
you reproduce the problems.  You could also try disabling NCQ and/or using a
different SATA controller (Silicon Image SiI 3132 based PCIe cards are
available very inexpensively) to see if this helps.

Thanks,

Tim.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
