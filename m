From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Mon, 20 Jul 2009 08:26:52 GMT
Message-ID: <200907200826.n6K8Qqqf018235@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60537 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZGTI0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2009 04:26:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6K8QqOU018236
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2009 08:26:52 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #28 from Ronan Guilfoyle <ronan.guilfoyle@modeva.ie>  2009-07-20 08:26:49 ---
I used the kernel command line 'pci=nomsi' and the problem has not been seen
since.
Three servers that all showed this problem are now running fine for over 6
weeks.  This may not be a fix, but it appears to be a perfectly goo wotkaround
for me.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
