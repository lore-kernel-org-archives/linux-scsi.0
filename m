From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Sat, 23 Jan 2010 14:29:12 GMT
Message-ID: <201001231429.o0NETCu7032098@demeter.kernel.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37376 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab0AWO3N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2010 09:29:13 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0NETCr1032099
	for <linux-scsi@vger.kernel.org>; Sat, 23 Jan 2010 14:29:12 GMT
In-Reply-To: <bug-14877-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14877





--- Comment #8 from Oleg Gawriloff <barzog@telecom.by>  2010-01-23 14:29:11 ---
Hmm, I've running my system without any problems more then year. I've
understand the point that if someone see MSI instability on lpfc it should be
turned off by default, but is there any way to activate MSI by hand?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
