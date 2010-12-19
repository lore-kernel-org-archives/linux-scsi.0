From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 02:34:35 GMT
Message-ID: <201012190234.oBJ2YZP4003544@demeter1.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37915 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab0LSCeg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Dec 2010 21:34:36 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBJ2YZnl003545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 02:34:35 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192


Matt Turner <mattst88@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #40772|0                           |1
        is obsolete|                            |




--- Comment #3 from Matt Turner <mattst88@gmail.com>  2010-12-19 02:34:28 ---
Created an attachment (id=40782)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=40782)
3ware-9500s: lspci, dmesg, /proc/io{mem,ports}

Whoops. Sorry about that. Reattached.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
