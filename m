From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Sun, 15 May 2011 11:14:01 GMT
Message-ID: <201105151114.p4FBE13D031898@demeter1.kernel.org>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:34542 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1EOLOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 May 2011 07:14:03 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4FBE1Kn031899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 15 May 2011 11:14:01 GMT
In-Reply-To: <bug-33802-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802





--- Comment #6 from Stefan Richter <stefanr@s5r6.in-berlin.de>  2011-05-15 11:14:00 ---
Fixed by https://git.kernel.org/linus/86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
in 2.6.39-rc6, with an additional required fix
https://git.kernel.org/linus/c055f5b2614b4f758ae6cc86733f31fa4c2c5844 in
2.6.39-rc7.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
