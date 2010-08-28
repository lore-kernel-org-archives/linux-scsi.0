From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Sat, 28 Aug 2010 15:47:55 GMT
Message-ID: <201008281547.o7SFlted003935@demeter1.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49015 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0H1Pr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Aug 2010 11:47:58 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7SFltQg003937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 28 Aug 2010 15:47:55 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #38 from starlight@binnacle.cx  2010-08-28 15:47:50 ---
Created an attachment (id=28191)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=28191)
boot-time messages with logging_level=0x1F8

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
