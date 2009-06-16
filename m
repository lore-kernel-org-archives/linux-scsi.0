From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13547] Buffer overrun in FlashPoint.c
Date: Tue, 16 Jun 2009 22:24:36 GMT
Message-ID: <200906162224.n5GMOam0004589@demeter.kernel.org>
References: <bug-13547-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48956 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZFPWYd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 18:24:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5GMOamL004590
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 22:24:36 GMT
In-Reply-To: <bug-13547-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13547





--- Comment #1 from Randy Dunlap <randy.dunlap@oracle.com>  2009-06-16 22:24:35 ---
How about the if-block just above line 1222?
Won't it prevent line 1222 from being executed when thisCard ==
MAX_CARDS?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
