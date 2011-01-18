From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26992] iscsi session re-establishment by client does not work
 (auth method rejected by target)
Date: Tue, 18 Jan 2011 00:13:47 GMT
Message-ID: <201101180013.p0I0DlLY019315@demeter2.kernel.org>
References: <bug-26992-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45977 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1ARANs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 19:13:48 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0I0Dl2t019316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 00:13:47 GMT
In-Reply-To: <bug-26992-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26992





--- Comment #1 from Mark <bugzilla-kernel-org-sux2k0@mstier.de>  2011-01-18 00:13:46 ---
FYI: to reproduce the bug, it should be sufficient to kill -KILL iscsid on the
client, and then restart it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
