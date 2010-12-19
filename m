From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 19:16:30 GMT
Message-ID: <201012191916.oBJJGU9j005667@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:44434 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab0LSTQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 14:16:31 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBJJGUVp005668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 19:16:30 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #8 from Adam Radford <aradford@gmail.com>  2010-12-19 19:16:23 ---
Ralf,

The 3w-9xxx driver is currently calling ioremap(), then using readl()/writel()
calls for memory mapped I/O.  

Are you suggesting we need to call iomap() and ioread32/iowrite32() for MIPS to
work?

-Adam

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
