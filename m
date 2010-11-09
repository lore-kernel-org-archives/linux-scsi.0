From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22512] no disks are found at driver start after upgrate from
 2.6.35.8 to 2.6.36
Date: Tue, 9 Nov 2010 21:15:48 GMT
Message-ID: <201011092115.oA9LFmqT005163@demeter2.kernel.org>
References: <bug-22512-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60111 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0KIVPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 16:15:48 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA9LFm5s005164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 9 Nov 2010 21:15:48 GMT
In-Reply-To: <bug-22512-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22512


Andrew Vasquez <andrew.vasquez@qlogic.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andrew.vasquez@qlogic.com




--- Comment #1 from Andrew Vasquez <andrew.vasquez@qlogic.com>  2010-11-09 21:15:44 ---
Could you test with the following patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b0cd579cde8ee0c7ed52239531ba09bcbc5b54c2

Applied to 2.6.36?  The patch above is already in 2.6.37-rc1.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
