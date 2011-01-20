From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26992] iscsi session re-establishment by client does not work
 (auth method rejected by target)
Date: Thu, 20 Jan 2011 20:30:42 GMT
Message-ID: <201101202030.p0KKUgud027128@demeter1.kernel.org>
References: <bug-26992-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55863 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1ATUan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jan 2011 15:30:43 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0KKUgX2027129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2011 20:30:42 GMT
In-Reply-To: <bug-26992-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26992





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2011-01-20 20:30:39 ---
Reply-To: michaelc@cs.wisc.edu

On 01/20/2011 01:12 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
>
> BTW: v872 is not available at open-iscsi.org/bits. Otherwise I would have found
> it before filing this bug. :-)
>

Ah yeah, sorry about that. We are having trouble with access to 
open-iscsi.org. I cannot access it to update it, so I have been putting 
updates on http://kernel.org/pub/linux/kernel/people/mnc/open-iscsi/.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
