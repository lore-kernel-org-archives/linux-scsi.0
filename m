From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34412] Error-valued pointer dereferences in SCSI
Date: Thu, 5 May 2011 22:35:01 GMT
Message-ID: <201105052235.p45MZ1Uf019957@demeter2.kernel.org>
References: <bug-34412-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43535 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1EEWfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2011 18:35:02 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p45MZ11u019958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 5 May 2011 22:35:01 GMT
In-Reply-To: <bug-34412-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=34412


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org




--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2011-05-05 22:34:59 ---
(In reply to comment #0)

> drivers/scsi/scsi_devinfo.c:716: Dereferencing variable
> scsi_dev_info_add_list#devinfo_table, which may contain one of the following
> error codes: EINVAL* 
> 

This appears to be just wrong.  I see no such bug in scsi_dev_info_add_list().

I suggest that you look more closely at the code which the tool is generating
reports about, to identify false positives and to improve the tool.

When you have spotted some real bugs, please report them via email to
linux-kernel@vger.kernel.org.  Because hardly anyone reads bugzilla and to get
a developer to look at these issues I'd have to route the reports to the
linux-kernel list for you.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
