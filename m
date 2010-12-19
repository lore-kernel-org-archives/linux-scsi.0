From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 20:41:15 GMT
Message-ID: <201012192041.oBJKfFtl015501@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56049 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0LSUlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 15:41:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBJKfFmV015502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 20:41:15 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #9 from ralf@linux-mips.org  2010-12-19 20:41:10 ---
No.

The issue I mentioned only exists for ioports, those little critters accessed
with inX / outX instructions on x86.  readl / writel etc. are working ok afair.

And again it's only this multi-bus scenario that is affected.

  Ralf

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
