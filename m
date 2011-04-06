From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Wed, 6 Apr 2011 23:56:35 GMT
Message-ID: <201104062356.p36NuYTx023582@demeter1.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39787 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab1DFX4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2011 19:56:35 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p36NuZDu023583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2011 23:56:35 GMT
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212





--- Comment #6 from Ryan Underwood <nemesis@icequake.net>  2011-04-06 23:56:32 ---
Changed to an older card with firmware 8205, I haven't seen a hang in almost 3
weeks now.  Perhaps a weird firmware problem?  The changelogs don't indicate
that anything significant changed in the newer revs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
