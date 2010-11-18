From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21852] BUG: unable to handle kernel NULL pointer dereference at
 0000000c (elv_quiesce_start)
Date: Thu, 18 Nov 2010 22:54:07 GMT
Message-ID: <201011182254.oAIMs7cS008710@demeter2.kernel.org>
References: <bug-21852-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54471 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab0KRWyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 17:54:08 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAIMs7Sg008711
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 22:54:07 GMT
In-Reply-To: <bug-21852-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21852


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
     Kernel Version|                            |2.6.37-rc1




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
