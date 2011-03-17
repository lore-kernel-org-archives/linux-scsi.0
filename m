From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Thu, 17 Mar 2011 17:02:31 GMT
Message-ID: <201103171702.p2HH2V86017339@demeter1.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49306 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1CQRCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 13:02:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2HH2VtM017340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2011 17:02:31 GMT
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212





--- Comment #4 from Ryan Underwood <nemesis@icequake.net>  2011-03-17 17:02:29 ---
Today 2.6.27.3 hung, these were its last words on the serial console:

[661903.992040] aacraid: Host adapter abort request (2,0,0,0)
[661904.064211] aacraid: Host adapter abort request (2,0,0,0)
[661904.136081] aacraid: Host adapter reset request. SCSI hang ?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
