From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Thu, 10 Jul 2008 09:02:36 -0700 (PDT)
Message-ID: <20080710160236.66C60108048@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbYGJQCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 12:02:38 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6AG2awT022885
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2008 09:02:37 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #17 from kurk@shiftmail.org  2008-07-10 09:02 -------
Prakash, Sathya wrote:
> This may  be a problem due to enabling MSI for SPI controllers. I have posted another message in the list providing the correction patch which is already in scsi-misc tree. 
> If the problem is gone with changing the module parameter mpt_msi_enable=0 or by applying the patch http://marc.info/?l=linux-scsi&m=121131228827682&w=4 then it might be due to MSI enabling.
>   
Another good news: I confirm that yes, the problem is also fixed by the 
patch linked above by Sathya, and in that case it is not needed to 
specify option mpt_msi_enable=0 for mptbase. Any one of the two (patch 
or option) is enough to fix the problem.
It would be nice to see this patch in the final release of the 2.6.26 kernel
Thank you


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
