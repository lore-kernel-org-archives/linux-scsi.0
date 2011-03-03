From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] PCI doesn't work on BCM91250A MIPS board
Date: Thu, 3 Mar 2011 19:49:05 GMT
Message-ID: <201103031949.p23Jn5bc028107@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39933 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1CCTtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2011 14:49:06 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p23Jn5e2028108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Mar 2011 19:49:05 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192


Matt Turner <mattst88@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|3w-{9,x}xxx don't work on   |PCI doesn't work on
                   |big-endian MIPS             |BCM91250A MIPS board




--- Comment #14 from Matt Turner <mattst88@gmail.com>  2011-03-03 19:48:59 ---
http://www.cyrius.com/debian/bcm91250a/hardware.html lists hardware that is
confirmed working with the bcm91250a.

When I received it, it had installed a Silicon Image card, which I've confirmed
doesn't work, much in the same way everything else doesn't work with recent
kernels. I can only imagine that it used to work, since it was installed.

At the time, I think the system had 2.6.18 on it, so I guess I'll confirm that
.18 works and then try to bisect.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
