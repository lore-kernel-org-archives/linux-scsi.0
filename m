From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Mon, 30 Jan 2012 18:10:23 GMT
Message-ID: <201201301810.q0UIANmx012817@bugzilla.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:52389 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2A3SKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2012 13:10:24 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0UIANCN012818
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2012 18:10:23 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688


Darrick J. Wong <djwong@us.ibm.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong@us.ibm.com




--- Comment #12 from Darrick J. Wong <djwong@us.ibm.com>  2012-01-30 18:10:22 ---
This is probably a long shot, but does https://lkml.org/lkml/2011/5/27/367 help
you?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
