From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 6921] cpqarray fails to detect array when built as a module
Date: Fri, 28 Mar 2008 07:45:12 -0700 (PDT)
Message-ID: <20080328144512.C660F11D109@picon.linux-foundation.org>
References: <bug-6921-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757716AbYC1Ope (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 10:45:34 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2SEjC86017169
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2008 07:45:13 -0700
In-Reply-To: <bug-6921-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=6921





------- Comment #4 from joshua@rubixlinux.org  2008-03-28 07:45 -------
Hi Natalie,

I no longer have access to the hardware (nor have I for some time now). But we
did get things working. As I remember, the kernel in Debian 4.0 (Etch) worked
out of the box. Please see the debian bug report listed above to follow that
discussion. What I do not remember was if the fix was in the vanilla source or
in the debian patch set.

It looks like this patch was the one that fixed things:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920

Thanks,
Joshua


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
