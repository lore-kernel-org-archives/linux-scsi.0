From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] PCI doesn't work on BCM91250A MIPS board
Date: Fri, 4 May 2012 00:07:28 GMT
Message-ID: <201205040007.q4407SQY028985@bugzilla.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:56411 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2EDAH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 20:07:29 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q4407SbC028986
	for <linux-scsi@vger.kernel.org>; Fri, 4 May 2012 00:07:28 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192


Matt Turner <mattst88@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |WILL_NOT_FIX




--- Comment #17 from Matt Turner <mattst88@gmail.com>  2012-05-04 00:07:27 ---
I gave up on the 3Ware 9500S and got a 64-bit PCI silicon image SATA controller
that works fine.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
