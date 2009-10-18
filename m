From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Sun, 18 Oct 2009 03:06:37 GMT
Message-ID: <200910180306.n9I36bHJ029167@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48315 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZJRDGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Oct 2009 23:06:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9I36bKZ029168
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2009 03:06:37 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #18 from Tejun Heo <tj@kernel.org>  2009-10-18 03:06:34 ---
The strace output doesn't indicate anything suspicious.  It's just polling for
event w/ 2 sec timeout.  I don't see how that could cause high cpu usage. 
Wendall, can you please strace the process which is consuming cpu?  Also, is
the wasted cpu time system or user?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
