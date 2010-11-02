From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 21852] BUG: unable to handle kernel NULL pointer dereference at
 0000000c (elv_quiesce_start)
Date: Tue, 2 Nov 2010 20:40:33 GMT
Message-ID: <201011022040.oA2KeXwm002786@demeter1.kernel.org>
References: <bug-21852-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34624 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0KBUkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 16:40:33 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA2KeXS1002787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2010 20:40:33 GMT
In-Reply-To: <bug-21852-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=21852


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |21782




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
