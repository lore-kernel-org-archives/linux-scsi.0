From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13547] Buffer overrun in FlashPoint.c
Date: Fri, 25 Feb 2011 03:48:55 GMT
Message-ID: <201102250348.p1P3mt4j010825@demeter1.kernel.org>
References: <bug-13547-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48226 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab1BYDs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 22:48:56 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1P3muE4010826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 03:48:56 GMT
In-Reply-To: <bug-13547-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13547





--- Comment #3 from L.C. <chenliunju@gmail.com>  2011-02-25 03:48:51 ---
Created an attachment (id=49072)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=49072)
Patch for bug 13547

Fix the potential bu
er overrun by making fewer iterations in the for loop.
This patch
is generated automatically by the tool R2Fix.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.