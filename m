From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11194] megaraid_mbox kernel panic during st driver
 initialization
Date: Fri, 3 Dec 2010 13:16:29 GMT
Message-ID: <201012031316.oB3DGTnR013538@demeter1.kernel.org>
References: <bug-11194-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59422 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0LCNQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 08:16:30 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oB3DGTrZ013561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 3 Dec 2010 13:16:29 GMT
In-Reply-To: <bug-11194-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11194


Frederic LIETART <thelinuxfr@free.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |thelinuxfr@free.fr




--- Comment #6 from Frederic LIETART <thelinuxfr@free.fr>  2010-12-03 13:16:24 ---
Hi,

Similar problem wich Xserve G5 and MegaRAID Card on Debian Lenny et Squeeze.
Screenshot :
http://dl.dropbox.com/u/165177/img/IMG_0200.jpg
http://dl.dropbox.com/u/165177/img/IMG_0201.jpg
http://dl.dropbox.com/u/165177/img/IMG_0201.jpg

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
