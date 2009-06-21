From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Sun, 21 Jun 2009 18:58:28 GMT
Message-ID: <200906211858.n5LIwS5j027520@demeter.kernel.org>
References: <bug-13594-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60769 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZFUS61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2009 14:58:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5LIwTUa027538
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2009 18:58:29 GMT
In-Reply-To: <bug-13594-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #3 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2009-06-21 18:58:28 ---
(In reply to comment #1)
> This is a message the kernel prints out on all recovered error returns
> (except those marked REQ_QUIET).  It's purely informational and doesn't
> affect return processing of the command at all, so the kernel is
> actually treating this as a successful completion not an error.

OK.

> So this sounds like the bug ... however, for the LSI card, this bug will
> be in the SAT layer in the fusion firmware.  I can shut the kernel up by
> making the recovered error processing clause look for 01/00/1D as well
> as REQ_QUIET, but it won't affect this problem.

I tried reporting this to the Linux fusionmpt driver people a while ago, but
never received any response (thus this bug)... I guess I'm out of luck, then,
if there's nothing that can be done for it in the kernel. It's a bit weird,
though; one would believe people ran smartd on their systems and discovered
this already.

/* Steinar */

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
