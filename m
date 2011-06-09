From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] killing requests for dead queue
Date: Thu, 9 Jun 2011 17:12:38 GMT
Message-ID: <201106091712.p59HCcok003916@demeter2.kernel.org>
References: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:57895 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1FIRMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2011 13:12:39 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p59HCcnI003917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2011 17:12:38 GMT
In-Reply-To: <bug-35682-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682


Michael Tokarev <mjt@tls.msk.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mjt@tls.msk.ru




--- Comment #1 from Michael Tokarev <mjt@tls.msk.ru>  2011-06-09 17:12:32 ---
The same happens to me with 2.6.39.1 - when I boot with an USB stick inserted
it hangs with the same message, but it boots fine w/o the stick attached.  I
can hotplug it later and it works fine.  What's "interesting" is that I
discovered the issue while trying to boot a new kernel from this USB stick, so
in that case it obviously _is_ inserted during boot...

There's one more case which may be related -- see e.g.
https://lkml.org/lkml/2011/6/3/33 -- that's how 2.6.38.8 were hanging here too,
but it appears that these QUEUE_FLAG_DEAD changes has been incorporated into
.39.1 already.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
