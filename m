From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 01:47:39 GMT
Message-ID: <201012190147.oBJ1lde4012343@demeter1.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:58182 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab0LSBrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Dec 2010 20:47:40 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBJ1ldWu012344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 01:47:39 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192


Adam Radford <aradford@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aradford@gmail.com




--- Comment #2 from Adam Radford <aradford@gmail.com>  2010-12-19 01:47:31 ---
The byte swap macros were never added to 3w-xxxx.  

Can you re-post 3w-9xxx lspci,dmesg, /proc/io{mem,port} attachment? 

The attachment doesn't actually contain what you reported it to.

-Adam

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
