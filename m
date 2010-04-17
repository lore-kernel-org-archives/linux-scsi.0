From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 9123] 2.6.23-rcX SG_GET_SCSI_ID regression?
Date: Sat, 17 Apr 2010 16:02:25 GMT
Message-ID: <201004171602.o3HG2PYY011767@demeter.kernel.org>
References: <bug-9123-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52894 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0DQQC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Apr 2010 12:02:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3HG2PPX011768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 17 Apr 2010 16:02:25 GMT
In-Reply-To: <bug-9123-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=9123





--- Comment #3 from Joerg Platte <bugzilla@jako.ping.de>  2010-04-17 16:02:06 ---
Just for the record: I tried to reproduce it today and the bug seems to be
fixed now. But it was there maybe 4 months ago.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
