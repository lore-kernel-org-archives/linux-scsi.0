From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16021] mptsas target reset under heavy duty
Date: Tue, 25 May 2010 20:40:11 GMT
Message-ID: <201005252040.o4PKeBVV016008@demeter.kernel.org>
References: <bug-16021-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36531 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140Ab0EYUkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2010 16:40:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4PKeBV1016009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 25 May 2010 20:40:11 GMT
In-Reply-To: <bug-16021-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16021


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
         AssignedTo|linux-scsi@vger.kernel.org  |kashyap.desai@lsi.com




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
