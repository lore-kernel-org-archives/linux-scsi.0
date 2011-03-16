From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Wed, 16 Mar 2011 17:45:17 GMT
Message-ID: <201103161745.p2GHjHn8020926@demeter2.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39195 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1CPRpS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 13:45:18 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2GHjH8W020927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 17:45:18 GMT
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212





--- Comment #2 from Ryan Underwood <nemesis@icequake.net>  2011-03-16 17:45:17 ---
Also, I have tried a controller firmware 4.2-0[8205] as well as 8208, and on
two different controllers, both exhibit the abort/panic problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
