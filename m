From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14157] end_request: I/O error, dev cciss/cXdX, sector 0
Date: Sat, 12 Sep 2009 20:49:22 GMT
Message-ID: <200909122049.n8CKnMWB001999@demeter.kernel.org>
References: <bug-14157-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49757 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZILUtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2009 16:49:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8CKnMNj002000
	for <linux-scsi@vger.kernel.org>; Sat, 12 Sep 2009 20:49:22 GMT
In-Reply-To: <bug-14157-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14157


Misha Labjuk <spike@ml.yaroslavl.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |spike@ml.yaroslavl.ru




--- Comment #1 from Misha Labjuk <spike@ml.yaroslavl.ru>  2009-09-12 20:49:21 ---
I think this is not scsi bug.

I get same errors flood with IDE disc. 

SiS5513 EIDE Controller with drive

Model Family:     Seagate Barracuda ATA IV family
Device Model:     ST320011A


Sep 12 17:08:02 ololo XFS mounting filesystem dm-0
Sep 12 17:08:02 ololo Ending clean XFS mount for filesystem: dm-0
Sep 12 17:08:02 ololo end_request: I/O error, dev hda, sector 0
Sep 12 17:08:02 ololo end_request: I/O error, dev hda, sector 0
...
and more 50 messages per second logged.



This is a regression.  2.6.30.6 last not affected version. 2.6.31 first
affected.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
