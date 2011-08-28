From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41872] Kernel crashes after ejecting of Samsung U5 player (just
 a flash stick)
Date: Sun, 28 Aug 2011 15:13:36 GMT
Message-ID: <201108281513.p7SFDabs027207@demeter1.kernel.org>
References: <bug-41872-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36088 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1H1PNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 11:13:36 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7SFDauL027208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 15:13:36 GMT
In-Reply-To: <bug-41872-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41872





--- Comment #13 from wolfram@ritsuka.org  2011-08-28 15:13:34 ---
Hmmm. Working like a charm. I can't insist that problem is really solved, but
I've five successfull ejections without any problem, so looks like that.

wolfy@core ~ % uname -a
Linux core 3.1.0-rc3-git3-00 #1 SMP PREEMPT Sun Aug 28 22:01:43 NOVST 2011
x86_64 Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz GenuineIntel GNU/Linux

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
