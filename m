From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19642] 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Sun, 3 Oct 2010 18:37:14 GMT
Message-ID: <201010031837.o93IbECN001547@demeter2.kernel.org>
References: <bug-19642-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:52849 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0JCShP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2010 14:37:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o93IbEFx001548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 3 Oct 2010 18:37:14 GMT
In-Reply-To: <bug-19642-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=19642


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |16444




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
