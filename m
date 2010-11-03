From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21852] BUG: unable to handle kernel NULL pointer dereference at
 0000000c (elv_quiesce_start)
Date: Wed, 3 Nov 2010 18:38:14 GMT
Message-ID: <201011031838.oA3IcEJo011883@demeter2.kernel.org>
References: <bug-21852-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:53944 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0KCSiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2010 14:38:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oA3IcEC4011884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 3 Nov 2010 18:38:14 GMT
In-Reply-To: <bug-21852-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21852


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
