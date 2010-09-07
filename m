From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Tue, 7 Sep 2010 23:04:42 GMT
Message-ID: <201009072304.o87N4gla031843@demeter1.kernel.org>
References: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46083 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0IGXEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 19:04:43 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o87N4gsW031844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 7 Sep 2010 23:04:42 GMT
In-Reply-To: <bug-17822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822


Wayne Boyer <wayneb@linux.vnet.ibm.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wayneb@linux.vnet.ibm.com




--- Comment #4 from Wayne Boyer <wayneb@linux.vnet.ibm.com>  2010-09-07 23:04:39 ---
The problem in the IPR driver is fixed with this patch:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=c5f10187965f93ef7ef67da9c7c449b13b6dee1b

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
