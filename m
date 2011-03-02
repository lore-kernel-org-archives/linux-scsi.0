From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30062] Huge amounts of "HDIO_GET_IDENTITY failed for /dev/sr0"
 messages during boot
Date: Wed, 2 Mar 2011 00:19:10 GMT
Message-ID: <201103020019.p220JAQK002998@demeter1.kernel.org>
References: <bug-30062-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59179 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab1CBATL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2011 19:19:11 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p220JAjp002999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2011 00:19:11 GMT
In-Reply-To: <bug-30062-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=30062


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
          Component|SCSI                        |Serial ATA
             Blocks|                            |27352
         AssignedTo|linux-scsi@vger.kernel.org  |jgarzik@pobox.com




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
