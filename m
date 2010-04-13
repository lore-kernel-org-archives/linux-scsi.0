From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15721] mptsas cannot dectect hotplugged harddisks occasionally
Date: Tue, 13 Apr 2010 19:18:11 GMT
Message-ID: <201004131918.o3DJIBFd003143@demeter.kernel.org>
References: <bug-15721-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51270 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0DMTSN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2010 15:18:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3DJICKk003144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2010 19:18:12 GMT
In-Reply-To: <bug-15721-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15721





--- Comment #7 from Andrew Morton <akpm@linux-foundation.org>  2010-04-13 19:18:03 ---
Please don't send patches via bugzilla - it causes lots of problems with
our usual patch management and review processes.

Please send this patch via email as per Documentation/SubmittingPatches. 
Suitable recipients may be found via scripts/get_maintainer.pl.  Please
also cc myself on the email.

Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
