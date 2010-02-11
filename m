From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Thu, 11 Feb 2010 13:31:02 GMT
Message-ID: <201002111331.o1BDV2Qg022221@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55075 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0BKNbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 08:31:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1BDV3OZ022235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2010 13:31:03 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001





--- Comment #12 from mi_whitebrook_13@gmx.at  2010-02-11 13:30:16 ---
Applied the patch on all our systems which were exhibiting this bug. The error
message in dmesg is gone now. Dell OMSA still works as expected, including
omreport and the Dell OpenManage Web Application.
Thanks for the fast fix!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
