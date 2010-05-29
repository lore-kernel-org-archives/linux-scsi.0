From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16070] Fail to issue Start/Stop Unit
Date: Sat, 29 May 2010 00:57:59 GMT
Message-ID: <201005290057.o4T0vxUM027688@demeter.kernel.org>
References: <bug-16070-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47554 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0E2A6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 20:58:00 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4T0vxi8027689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 29 May 2010 00:57:59 GMT
In-Reply-To: <bug-16070-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16070





--- Comment #3 from Ian Dall <ian@beware.dropbear.id.au>  2010-05-29 00:57:56 ---
Ah, thanks. That works perfectly!

I knew that traditionally this wasn't supported in linux (as per comment #1)
but I also understood that the functionality had been added in recent kernels.

In my defence, I can't find any reference to this in "man sd' nor with "grep
allow_restart Documentation/scsi/*".

Can this be treated as a documentation bug?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
