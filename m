From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41552] Performance of writing and reading from multiple drives
 decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and beyond)
Date: Mon, 22 Aug 2011 15:21:32 GMT
Message-ID: <201108221521.p7MFLWPm031042@demeter1.kernel.org>
References: <bug-41552-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:45937 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1HVPVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 11:21:33 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7MFLWeX031043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2011 15:21:32 GMT
In-Reply-To: <bug-41552-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41552





--- Comment #1 from Mark Petersen <mpete_06@hotmail.com>  2011-08-22 15:21:31 ---
Created an attachment (id=69622)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=69622)
The .config used to build the 2.6.37 Kernel

This is the .config used to build the 2.6.37 Kernel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
