From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14534] mvsas : repeatably disconnects all disks during RAID6
 resync
Date: Sat, 14 Nov 2009 11:04:00 GMT
Message-ID: <200911141104.nAEB40o4019814@demeter.kernel.org>
References: <bug-14534-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48521 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZKNLDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2009 06:03:54 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAEB40A0019815
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2009 11:04:00 GMT
In-Reply-To: <bug-14534-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14534





--- Comment #10 from Arno Wagner <arno@wagner.name>  2009-11-14 11:03:55 ---
I did apply patches 1...6 to 2.6.32-rc7 successfully. Patch 7 applies but then
causes a compile error (looks like the same thing Christian found).

Function looks good. No issues on building the RAID6. No issues during fast
sequential reading or writing. No issues when compiling kernels in a loop. Hot
plugging works. Performance looks about right and is at roughly 1.5 times the
throughput of the slowest disk for sequential reading and writing.

I will do some more tests and if anything shows up, I will post it here.

Thanks for the quick fix, Andy!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
