From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25602] [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Thu, 30 Dec 2010 10:43:49 GMT
Message-ID: <201012301043.oBUAhnor012959@demeter2.kernel.org>
References: <bug-25602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36544 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0L3Knu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Dec 2010 05:43:50 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBUAhnF8012960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 30 Dec 2010 10:43:50 GMT
In-Reply-To: <bug-25602-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25602


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |DUPLICATE




--- Comment #2 from Rafael J. Wysocki <rjw@sisk.pl>  2010-12-30 10:43:46 ---
No, but it's better to create a bug entry first and put a link to it into
your e-mail report.  Then, we'll likely notice that the bug entry already
exists and we won't create another bug entry for it.

*** This bug has been marked as a duplicate of bug 25392 ***

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
