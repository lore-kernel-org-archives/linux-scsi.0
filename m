From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 21:18:38 GMT
Message-ID: <201005272118.o4RLIcZP008498@demeter.kernel.org>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53618 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab0E0VSj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 17:18:39 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4RLIcM0008499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2010 21:18:38 GMT
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058





--- Comment #2 from Alan Stern <stern@rowland.harvard.edu>  2010-05-27 21:18:37 ---
On Thu, 27 May 2010, Mark Hounschell wrote:

> >> As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
> >> byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks

> >> The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
> >> available.

> Yes, I can. But first let me ask, since reverting this patch on at least
> 2.6.32 - 2.6.34 does not help, would it possibly be better if I did a
> little more work to find out where it stops working with the above patch
> reverted or not?

I'd do 2.6.27 first, since that's where the problem started.  Then move 
on to 2.6.34.  There may be two different problems.

Alan Stern

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
