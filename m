From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Thu, 10 Jul 2008 07:25:23 -0700 (PDT)
Message-ID: <20080710142523.6062610805E@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702AbYGJOZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 10:25:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6AEPN6t013778
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2008 07:25:24 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045





------- Comment #16 from kurk@shiftmail.org  2008-07-10 07:25 -------
Hi all,
Good news! James and Sathya were correct, the bug is related to MSI: 
specifying mpt_msi_enable=0 as option for the mptbase module solves the 
problem and the system can boot as usual.

Having said this, do you still want me to try a patch, or perform some 
additional test?

Just out of curiosity: do you intend to eventually modify the kernel so 
to "support" and work around buggy hardware like the one we have (IBM 
xSeries 335), so that Linux can work out of the box even on this hardware?

Thank everybody for your help


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
