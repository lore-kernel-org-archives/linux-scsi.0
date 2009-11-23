From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Mon, 23 Nov 2009 12:10:06 GMT
Message-ID: <200911231210.nANCA60H019503@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56758 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbZKWMKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2009 07:10:00 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nANCA6sN019505
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2009 12:10:06 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #18 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-23 12:10:04 ---
Created an attachment (id=23877)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23877)
Console output, 2.6.30.3, fixed tape block size 512k, patch by FUJITA Tomonori
2009-11-19

The patch you sent changes the behavior: I still get the EIO after (in this
case) 239 I/O requests while writing to the tape; but the machine no longer
hard-crashes with a BUG.

[I've removed the try_rdio=0/try_wdio=0 module parameters for this test.]

Attached is the console log as usual with my comments interspersed; if I read
this correctly "st0: Number of r/w requests 239, dio used in 1, pages 128."
direct I/O is used at least once before the problem occurs.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
