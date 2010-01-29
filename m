From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Fri, 29 Jan 2010 00:46:24 GMT
Message-ID: <201001290046.o0T0kOV4029483@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57206 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0A2AqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2010 19:46:25 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0T0kO6u029484
	for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2010 00:46:24 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


Andrew Vasquez <andrew.vasquez@qlogic.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andrew.vasquez@qlogic.com




--- Comment #30 from Andrew Vasquez <andrew.vasquez@qlogic.com>  2010-01-29 00:46:17 ---
Csillag,

Prior to the FW update, were you seeing the failures while
using the 'pci=nomsi' workaround?  What were the firmware
versions used in your testing -- before and after?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
