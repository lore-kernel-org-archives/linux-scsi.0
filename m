From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13547] Buffer overrun in FlashPoint.c
Date: Wed, 2 Mar 2011 20:27:32 GMT
Message-ID: <201103022027.p22KRWvX018248@demeter2.kernel.org>
References: <bug-13547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:49982 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1CBU1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2011 15:27:33 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p22KRWCL018249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2011 20:27:32 GMT
In-Reply-To: <bug-13547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13547





--- Comment #5 from Randy Dunlap <randy.dunlap@oracle.com>  2011-03-02 20:27:29 ---
The patch prevents the following test from returning FAILURE,
which is a new error, so the patch is bad.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
