From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 31 Mar 2009 16:02:11 GMT
Message-ID: <200903311602.n2VG2BVN016001@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48069 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbZCaQCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2009 12:02:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2VG2BGU016002
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2009 16:02:11 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


mike <mb11628@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mb11628@yahoo.com




--- Comment #25 from mike <mb11628@yahoo.com>  2009-03-31 16:02:09 ---
Are there any updates on this bug?  We are planning on installing 4 new
database servers in the next couple of weeks using Debian Lenny amd64 (2.6.26
kernel) on servers with dual Qlogic 2460 HBAs using multipathd, connecting to
an EMC Clarion SAN.

I came across this bug, but couldn't gauge how big of a concern this should be
for us.  Is it recommended to use a kernel version of 2.6.20 or older at this
point or is the behavior seen in this bug a rare/special case?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
