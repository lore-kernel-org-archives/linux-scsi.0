From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Fri, 29 Oct 2010 03:34:33 GMT
Message-ID: <201010290334.o9T3YXUA005779@demeter2.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:44379 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0J2Ded (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 23:34:33 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9T3YXJB005780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 03:34:33 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652





--- Comment #4 from pipa.tk <bigplum@gmail.com>  2010-10-29 03:34:31 ---
Which harddisk ary you used, ST31500341AS?

Relate bug: https://bugzilla.kernel.org/show_bug.cgi?id=13594

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
