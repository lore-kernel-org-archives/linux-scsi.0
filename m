From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Sat, 28 Aug 2010 15:44:29 GMT
Message-ID: <201008281544.o7SFiTAj002853@demeter1.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38382 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0H1Poa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Aug 2010 11:44:30 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7SFiTco002854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 28 Aug 2010 15:44:29 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #32 from starlight@binnacle.cx  2010-08-16 16:00:33 ---
Happened again with 'smartd' disabled and with *latest*
kernel, LSI device driver and LSI IT (initiator target)
firmware.  Took 37 days of uptime for it to happen.
Failure was during moderate write activity rather than
light activity as with the 'smartd' pass-through
transactions.  Kernel messages attached.

kernel 5.5 2.6.18-194.8.1.el5
MPT2BIOS-7.05.01.00 (2010.02.09)
SAS2008-IT 5.00.00.00
LSI driver mpt2sas-05.00.00.00

--- Comment #33 from starlight@binnacle.cx  2010-08-16 16:04:36 ---
Created an attachment (id=27469)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27469)
kernel messages from failure

--- Comment #34 from starlight@binnacle.cx  2010-08-16 16:07:39 ---
Created an attachment (id=27470)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27470)
kernel messages from corresponding boot

--- Comment #35 from starlight@binnacle.cx  2010-08-28 15:43:16 ---
Another controller failure, this time with logging_level=0x1F8.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
