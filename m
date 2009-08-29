From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8213] Race: a lock is expected before calling
 BusLogic_WriteOutgoingMailbox, but it is not held in some case and it is held
 in other cases
Date: Sat, 29 Aug 2009 16:36:49 GMT
Message-ID: <200908291636.n7TGanpt013534@demeter.kernel.org>
References: <bug-8213-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46971 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZH2Qgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 12:36:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7TGanZN013535
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 16:36:49 GMT
In-Reply-To: <bug-8213-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8213


Lin Tan <tammy000@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #5 from Lin Tan <tammy000@gmail.com>  2009-08-29 16:36:49 ---
Ah, I think you are right, James.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
