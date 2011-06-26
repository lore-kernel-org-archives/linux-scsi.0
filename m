From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] killing requests for dead queue
Date: Sun, 26 Jun 2011 13:48:34 GMT
Message-ID: <201106261348.p5QDmYui008366@demeter2.kernel.org>
References: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56392 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1FZNsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jun 2011 09:48:35 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p5QDmYjD008367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 26 Jun 2011 13:48:34 GMT
In-Reply-To: <bug-35682-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682





--- Comment #2 from alust@alust.homeunix.com  2011-06-26 13:48:16 ---
Hello,

I've run into this issue too. Kernel 2.6.39 compiled from linux-source-2.6.39
debian package.

Any time I insert a flash stick or boot with the stick inserted I will got 

"killing requests for dead queue" message that is followed by "lost interrupt"
and "ide-atapi cmd 0x1e timed out".

Please let me know if any additioanal information is required.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
