From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21172] OOPS in disk_replace_part_tbl.
Date: Tue, 28 Dec 2010 22:09:30 GMT
Message-ID: <201012282209.oBSM9UYu017926@demeter2.kernel.org>
References: <bug-21172-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:47887 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0L1WJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2010 17:09:31 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBSM9Uux017927
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 22:09:30 GMT
In-Reply-To: <bug-21172-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21172


Pawel Sikora <pluto@agmk.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #3 from Pawel Sikora <pluto@agmk.net>  2010-12-28 22:09:27 ---
works fine on 2.6.36.2.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
