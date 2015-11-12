From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: 4.4 SCSI queue status
Date: Wed, 11 Nov 2015 22:55:52 -0500
Message-ID: <yq16117ub07.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25038 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbbKLDz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 22:55:56 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tAC3ttbS026453
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 03:55:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tAC3ttSN003241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 03:55:55 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tAC3tthm024435
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 03:55:55 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


As some of you may have noticed, I have been volunteered to help with
the SCSI tree going forward. Much like Christoph did for while. My
current tree is here:

http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/log/?h=4.4/scsi-queue

At this point I am done merging SCSI patches for 4.4. There was quite
the backlog and I probably missed a bunch. Sorry!

However, save for a couple of patch series from Hannes my SCSI folder is
now empty. Which means that for me to see something you will have to
resend to linux-scsi.

Most of my merge cycles have been spent on driver updates. I prioritized
those over core changes since we were essentially in the merge window
when I got enlisted(*). Will tackle the trickier core stuff for 4.5.

There were a couple of driver series that just missed the cut: The
HiSilicon SAS driver which required minor tweaks and two ufs patch
series which required comment feedback and/or reviews.

The rules of engagement haven't changed. Here they are, slightly updated
from the original version to reflect the omnipresent kbuild test robot
and a few other things:

 - A patch needs two positive reviews (non-author signoff, acked-by,
   reviewed-by or tested-by).

 - The patch must have been posted to linux-scsi and nobody has
   expressed any concerns about it.

 - The patch applies cleanly. Use checkpatch and git send-email.

 - The patch compiles without warnings on all relevant architectures and
   does not incur any 0-day kbuild test robot complaints.

 - Core changes survive a full xfstests run.

 - The patch must have a commit message that comprehensively describes
   what the patch does. Do not link to vendor bugzilla entries that
   require special access credentials. If there is anything of
   importance in bugzilla, put it in the commit message.

 - Resend the patches if you haven't received any feedback after a
   couple of weeks.

 - When you resend a patch or series make sure to record all existing
   reviewed-by/acked-by/tested-by tags.

 - Ping the list for additional reviewers.

(*) I will never merge during the merge window again!
    I will never merge during the merge window again!
    I will never merge during the merge window again!

-- 
Martin K. Petersen	Oracle Linux Engineering
