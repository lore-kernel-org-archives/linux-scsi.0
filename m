From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Mon, 5 Jul 2010 16:02:49 GMT
Message-ID: <201007051602.o65G2n1X002270@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44265 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0GEQCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2010 12:02:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o65G2noF002273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jul 2010 16:02:49 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #7 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-05 16:01:26 ---
The same problem is with 2.6.35-rc4.

Sorry i can't provide now full panic log from output console because server is
1000km from me.... - and there is limited access to monitor and console..

last good working kernel was 2.6.35-rc1

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
