From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31212] aacraid is generally unstable with newer kernels
Date: Sun, 28 Apr 2013 08:45:58 +0000 (UTC)
Message-ID: <20130428084558.8280711FB8B@bugzilla.kernel.org>
References: <bug-31212-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3D1IqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Apr 2013 04:46:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1F6920578
	for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2013 08:45:59 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 88F3A20566
	for <linux-scsi@vger.kernel.org>; Sun, 28 Apr 2013 08:45:58 +0000 (UTC)
In-Reply-To: <bug-31212-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31212


Sid <eu4ao0qfv2jhiuq@jetable.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |eu4ao0qfv2jhiuq@jetable.org




--- Comment #13 from Sid <eu4ao0qfv2jhiuq@jetable.org>  2013-04-28 08:45:57 ---
Hi everyone, 


I have Adaptec 6405E HW Card which make me crazy with these errors : 

[661903.992040] aacraid: Host adapter abort request (2,0,0,0)
[661904.064211] aacraid: Host adapter abort request (2,0,0,0)
[661904.136081] aacraid: Host adapter reset request. SCSI hang ?


This issue is when you use a new kernel. I have found the issue. 

Go to http://www.adaptec.com/fr-fr/ and upgrade the firmware of your hw card. 

I have 6405E and with all OS I have this errors (ebord request, SCSI hang) 
After the upgrade (yesterday) 18668 to 19076 and 19109 it works very well now. 

So, upgrade the firmware of your card and it could fix this error. 


I hope it can helps you.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
