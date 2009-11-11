From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Wed, 11 Nov 2009 20:50:45 GMT
Message-ID: <200911112050.nABKojna021576@demeter.kernel.org>
References: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44875 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871AbZKKUuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 15:50:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nABKojvN021577
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2009 20:50:45 GMT
In-Reply-To: <bug-14534-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534


Christian Vilhelm <christian.vilhelm@univ-lille2.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |christian.vilhelm@univ-lill
                   |                            |e2.fr




--- Comment #8 from Christian Vilhelm <christian.vilhelm@univ-lille2.fr>  2009-11-11 20:50:40 ---
I just tried the patches on 2.6.32-rc6, I did not apply the 7th patch as the
new libsas version is not in -rc6.
I could create a raid 5 array just fine on 6 SATA disks, using a 64xx based
card (Areca 1300). The raid-5 build was not possible without the patches (tried
many times with different configurations).
I will do some more tests in the coming days to confirm this.
Many thanks Andy for fixing this.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
