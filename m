From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8221] RACE: Lock is expected before calling
 ips_removeq_scb_head, but in some call chains not held!
Date: Sat, 29 Aug 2009 09:14:44 GMT
Message-ID: <200908290914.n7T9Eixh001275@demeter.kernel.org>
References: <bug-8221-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47618 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZH2JOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 05:14:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7T9Eipj001276
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 09:14:44 GMT
In-Reply-To: <bug-8221-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8221


Roland Kletzing <devzero@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




--- Comment #1 from Roland Kletzing <devzero@web.de>  2009-08-29 09:14:43 ---
Hello Ding, 

i`m curious how this report sits here unnoticed for so long. does that still
apply? i yes, can you please bring that up on linux-scsi mailinglist ?
thank you.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
