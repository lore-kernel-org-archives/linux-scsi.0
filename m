From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Thu, 29 Apr 2010 07:25:33 GMT
Message-ID: <201004290725.o3T7PXEd017634@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321Ab0D3Rb4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 13:31:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3T7PYUC017635
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Apr 2010 07:25:34 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #13 from Brian Sullivan <bexamous@gmail.com>  2010-04-29 07:25:25 ---
This issue seems to get no attention.  I would be happy to go buy some other
HBA controller but 1068E is used everywhere, I can't figure out what to buy as
an alternative.

Is this a firmware bug?  There is a billion firmwares for the 1068E, I'm stuck
with an onboard controller and not sure if its possible to update the firmware.
 Would it be worth buying some addin card to be able to try different
firmwares?

Does LSI care about this?  If not, fine.  If so, is the problem you cannot
reproduce it?

If you google a bit you can find many people running into this bug.

Argh, I'm so frustrated.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
