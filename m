From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] SCSI Generic (sg): BUG: sleeping function called from
 invalid context
Date: Thu, 26 Mar 2009 12:29:06 GMT
Message-ID: <200903261229.n2QCT6VU016367@demeter.kernel.org>
References: <bug-12945-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43202 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZCZN0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 09:26:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QCT6R5016368
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 12:29:06 GMT
In-Reply-To: <bug-12945-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12945





--- Comment #1 from Tobias <txtoxtox285@googlemail.com>  2009-03-26 12:29:05 ---
Created an attachment (id=20686)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20686)
Stack trace on timeout (2.6.28.7)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
