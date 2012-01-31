From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Tue, 31 Jan 2012 05:06:08 GMT
Message-ID: <201201310506.q0V568IU025167@bugzilla.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54001 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2AaFGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2012 00:06:09 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0V568GJ025168
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2012 05:06:08 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688


kdesai <kashyap.desai@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kashyap.desai@lsi.com




--- Comment #16 from kdesai <kashyap.desai@lsi.com>  2012-01-31 05:06:06 ---
(In reply to comment #14)
> I've asked a few times, but LSI has never picked it up.  I can try linux-scsi
> again, but it'd be useful to have at least a few supporters to confirm that it
> doesn't break anything. :)

I was now moved to other role inside LSI, so could not focus on this. Sorry for
delay. My colleague "Lakshmi" is looking this issue and she wants helps to
reproduce the issue at LSI.

Latest, I was also not able to reproduce the this issue due to h/w components.
If someone can help Lakshmi to reproduce this issue locally, LSI can look at
the possible root cause.

BTW, Can you compare it with latest "upstream" vs "4.18.00.00" ?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
