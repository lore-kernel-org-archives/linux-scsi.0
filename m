From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 25 Nov 2009 00:21:51 GMT
Message-ID: <200911250021.nAP0Lp33017612@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45946 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbZKYAVp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 19:21:45 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAP0LpT6017613
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2009 00:21:51 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #20 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-25 00:21:50 ---
Reply-To: fujita.tomonori@lab.ntt.co.jp

On Mon, 23 Nov 2009 12:10:06 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #18 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-23 12:10:04 ---
> Created an attachment (id=23877)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23877)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=23877)
> Console output, 2.6.30.3, fixed tape block size 512k, patch by FUJITA Tomonori
> 2009-11-19
> 
> The patch you sent changes the behavior: I still get the EIO after (in this
> case) 239 I/O requests while writing to the tape; but the machine no longer
> hard-crashes with a BUG.
> 
> [I've removed the try_rdio=0/try_wdio=0 module parameters for this test.]
> 
> Attached is the console log as usual with my comments interspersed; if I read
> this correctly "st0: Number of r/w requests 239, dio used in 1, pages 128."
> direct I/O is used at least once before the problem occurs.

As Kai said, it doesn't look like a kernel log with the patch
applied. With the patch, the kernel becomes more verbose.

Can you check again?

Thanks,

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
