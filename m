From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Tue, 18 May 2010 15:04:29 GMT
Message-ID: <201005181504.o4IF4Tea017115@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60294 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab0ERPEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 11:04:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4IF4TCG017117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 18 May 2010 15:04:29 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13594





--- Comment #16 from Ken Stailey <kstailey@yahoo.com>  2010-05-18 15:04:15 ---
If this bug report is to be closed on the grounds that it only encompasses
suppressing some log messages can anyone post the ID of any bug reports that
are for the "real" LSI MPT driver issues?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
