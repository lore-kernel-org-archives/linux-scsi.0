From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26992] iscsi session re-establishment by client does not work
 (auth method rejected by target)
Date: Thu, 20 Jan 2011 19:12:38 GMT
Message-ID: <201101201912.p0KJCcg5016497@demeter1.kernel.org>
References: <bug-26992-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41614 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1ATTMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jan 2011 14:12:39 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0KJCcig016498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2011 19:12:38 GMT
In-Reply-To: <bug-26992-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26992


Mark <bugzilla-kernel-org-sux2k0@mstier.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #3 from Mark <bugzilla-kernel-org-sux2k0@mstier.de>  2011-01-20 19:12:33 ---
Thanks!

v872 works.

BTW: v872 is not available at open-iscsi.org/bits. Otherwise I would have found
it before filing this bug. :-)

I'll enter an Ubuntu bug -- maybe they didn't find it either.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
