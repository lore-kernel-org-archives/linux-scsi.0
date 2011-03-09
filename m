From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30762] Oops when plugging in an usb stick
Date: Wed, 9 Mar 2011 23:15:58 GMT
Message-ID: <201103092315.p29NFwO9020568@demeter2.kernel.org>
References: <bug-30762-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:51904 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1CIXP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2011 18:15:59 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p29NFwYo020599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2011 23:15:58 GMT
In-Reply-To: <bug-30762-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=30762


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
                 CC|                            |akpm@linux-foundation.org
          Component|SCSI                        |USB
         Resolution|INVALID                     |
         AssignedTo|linux-scsi@vger.kernel.org  |greg@kroah.com
            Product|IO/Storage                  |Drivers




--- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2011-03-09 23:15:55 ---
If the kernel ever goes BUG then that's a kernel bug.  So I'll reopen this and
hopefully the USB guys can take a look.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
