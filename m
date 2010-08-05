From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16490] "Assuming drive cache: write through" messages probably
 have wrong loglevel
Date: Thu, 5 Aug 2010 14:09:01 GMT
Message-ID: <201008051409.o75E91Uv003736@demeter.kernel.org>
References: <bug-16490-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39527 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231Ab0HEOJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 10:09:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o75E91KC003737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 14:09:01 GMT
In-Reply-To: <bug-16490-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16490


Tejun Heo <tj@kernel.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Serial ATA                  |SCSI
         AssignedTo|tj@kernel.org               |linux-scsi@vger.kernel.org




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
