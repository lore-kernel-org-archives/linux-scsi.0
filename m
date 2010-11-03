From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21852] BUG: unable to handle kernel NULL pointer dereference at
 0000000c (elv_quiesce_start)
Date: Wed, 3 Nov 2010 09:16:43 GMT
Message-ID: <201011030916.oA39Gh3U012635@demeter2.kernel.org>
References: <bug-21852-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:47762 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0KCJQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2010 05:16:44 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA39GhB8012636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Nov 2010 09:16:43 GMT
In-Reply-To: <bug-21852-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21852





--- Comment #1 from Fabio Comolli <fabio.comolli@gmail.com>  2010-11-03 09:16:39 ---
This bug is fixed. Please see this thread: http://lkml.org/lkml/2010/10/24/118
I suppose Linus actually reverted the offending commits but I'm not sure.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
