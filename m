From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36742] Fusion MPT2SAS driver fails to suspend to S3
 incorrectly, suspend to disk works.
Date: Mon, 6 Jun 2011 17:21:22 GMT
Message-ID: <201106061721.p56HLM08019322@demeter2.kernel.org>
References: <bug-36742-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42521 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1FFRVX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2011 13:21:23 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p56HLMjn019331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2011 17:21:22 GMT
In-Reply-To: <bug-36742-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=36742


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rjw@sisk.pl
          Component|Hibernation/Suspend         |Other
             Blocks|                            |7216
         AssignedTo|power-management_other@kern |scsi_drivers-other@kernel-b
                   |el-bugs.osdl.org            |ugs.osdl.org
            Product|Power Management            |SCSI Drivers




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
