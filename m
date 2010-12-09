From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21372] NULL pointer deference at disk_replace_part_tbl+0x32
Date: Thu, 9 Dec 2010 10:52:14 GMT
Message-ID: <201012091052.oB9AqE4Y008298@demeter2.kernel.org>
References: <bug-21372-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:36939 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab0LIKwP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 05:52:15 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oB9AqEgl008299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 9 Dec 2010 10:52:15 GMT
In-Reply-To: <bug-21372-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21372


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




--- Comment #4 from Florian Mickler <florian@mickler.org>  2010-12-09 10:52:13 ---
(this was the only commit I could find that somehow had something to do with
reverting, io and stat(s)...)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
