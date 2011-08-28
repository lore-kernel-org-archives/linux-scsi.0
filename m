From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41872] Kernel crashes after ejecting of Samsung U5 player (just
 a flash stick)
Date: Sun, 28 Aug 2011 14:49:33 GMT
Message-ID: <201108281449.p7SEnXgB010203@demeter2.kernel.org>
References: <bug-41872-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35892 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1H1Ote (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 10:49:34 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7SEnYG3010234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2011 14:49:34 GMT
In-Reply-To: <bug-41872-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41872





--- Comment #12 from Bart Van Assche <bvanassche@acm.org>  2011-08-28 14:49:30 ---
Never mind. It would help if you could verify whether this has been fixed in
3.1-rc3, available from http://kernel.org/. That version contains this patch:
http://www.spinics.net/lists/stable-commits/msg13017.html.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
