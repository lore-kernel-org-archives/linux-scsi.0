From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13982] [libata] (?) causing Hardlock in 2.6.30.4 during
 simultaneous read & write
Date: Sat, 15 Aug 2009 16:48:31 GMT
Message-ID: <200908151648.n7FGmV8r002183@demeter.kernel.org>
References: <bug-13982-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60009 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZHOQsa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2009 12:48:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7FGmVai002184
	for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2009 16:48:31 GMT
In-Reply-To: <bug-13982-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13982


Roland Kletzing <devzero@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




--- Comment #4 from Roland Kletzing <devzero@web.de>  2009-08-15 16:48:29 ---
this may be http://bugzilla.kernel.org/show_bug.cgi?id=13933
(someone mark it as duplicate then)

can you check if 2.6.29 works without problems ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
