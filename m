From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] killing requests for dead queue
Date: Sun, 28 Aug 2011 16:29:41 GMT
Message-ID: <201108281629.p7SGTfrh005958@demeter1.kernel.org>
References: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49154 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1H1Q3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 12:29:41 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7SGTfG6005959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 16:29:41 GMT
In-Reply-To: <bug-35682-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682





--- Comment #5 from alust@alust.homeunix.com  2011-08-28 16:28:33 ---
Yes, I also cannot reproduce this bug in 3.0.0

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
