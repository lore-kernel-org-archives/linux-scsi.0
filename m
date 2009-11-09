From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Mon, 9 Nov 2009 08:33:05 GMT
Message-ID: <200911090833.nA98X5nh008435@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43870 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZKIIc7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 03:32:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA98X55C008436
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2009 08:33:05 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563


Joachim Breuer <linux-kernel@jmbreuer.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Platform|All                         |x86-64




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
