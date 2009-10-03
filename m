From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14118] USB storage: "No sense [current]" when connecting
Date: Sat, 3 Oct 2009 21:29:41 GMT
Message-ID: <200910032129.n93LTf0B023770@demeter.kernel.org>
References: <bug-14118-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54197 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZJCVaR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2009 17:30:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n93LTfhE023771
	for <linux-scsi@vger.kernel.org>; Sat, 3 Oct 2009 21:29:41 GMT
In-Reply-To: <bug-14118-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14118





--- Comment #11 from Alan Stern <stern@rowland.harvard.edu>  2009-10-03 21:29:39 ---
Thanks for testing.  I will submit the patch for inclusion in 2.6.32 and
2.6.31.stable.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
