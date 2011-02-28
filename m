From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29442] target: Race between target driver unregistration and
 LUN removal
Date: Mon, 28 Feb 2011 23:43:11 GMT
Message-ID: <201102282343.p1SNhBVq028757@demeter2.kernel.org>
References: <bug-29442-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47083 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab1B1XnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 18:43:11 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1SNhBoe028758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2011 23:43:11 GMT
In-Reply-To: <bug-29442-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=29442





--- Comment #3 from nab <nab@linux-iscsi.org>  2011-02-28 23:43:09 ---
>From Bart's feedback the following commit in upstream lio-core-2.6.git appears
to resolve the issue using the latest lio-4.1 (v4.1.0-rc1) development code:

target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=90c9861627c2b5ab4a79fabf34ffb0c7f59fb34b

This patch has been queued for mainline .38 here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commitdiff;h=52208ae3fc60cbcb214c10fb8b82304199e2cc3a

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
