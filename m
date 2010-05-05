From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 5 May 2010 10:35:38 GMT
Message-ID: <201005051035.o45AZcka018568@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40650 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0EEKfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 06:35:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o45AZdXD018569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 5 May 2010 10:35:39 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831


Andrew Dunn <andrew.g.dunn.dod@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |andrew.g.dunn.dod@gmail.com




--- Comment #18 from Andrew Dunn <andrew.g.dunn.dod@gmail.com>  2010-05-05 10:35:17 ---
I anxiously await confirmation of this patch. This issue has been plaguing me
for quite a while. Just for verification the mpt2sas controllers don't have
problems with this? I was thinking of trying to get an AOC-USAS2-L8i
(http://www.supermicro.com/products/accessories/addon/AOC-USAS2-L8i.cfm?TYP=I)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
