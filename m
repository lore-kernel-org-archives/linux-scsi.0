From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Thu, 4 Feb 2010 11:00:57 GMT
Message-ID: <201002041100.o14B0vfY016040@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37829 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0BDLA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 06:00:58 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o14B0vnt016046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Feb 2010 11:00:57 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001





--- Comment #6 from Alex <mailatgoogl@gmail.com>  2010-02-04 11:00:54 ---
(In reply to comment #5)
> Created an attachment (id=24890)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24890) [details]
> patch to handle compat apps
> 
> The issue is probably caused by a 32bit application in a 64bit os. The 'open
> manage' here uses a 32bit pointer and the driver after the 'SCSI: megaraid_sas:
> fix 64 bit sense pointer truncation' works with it as if it was a 64bit
> pointer.
> The attached patch handles the situation on my test box.

thank you for the patch , it handles the issue , tested on 2.6.32.7 .

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
