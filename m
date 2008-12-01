From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12119] iscsi repeatedly times out
Date: Mon,  1 Dec 2008 08:20:11 -0800 (PST)
Message-ID: <20081201162011.0F6D5108041@picon.linux-foundation.org>
References: <bug-12119-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbYLAQUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 11:20:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB1GKBIM027840
	for <linux-scsi@vger.kernel.org>; Mon, 1 Dec 2008 08:20:12 -0800
In-Reply-To: <bug-12119-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12119





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-12-01 08:20 -------
Reply-To: michaelc@cs.wisc.edu

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12119
> 
> 
> 
> 
> 
> ------- Comment #3 from ian@beware.dropbear.id.au  2008-12-01 05:39 -------
> Thanks. The patch wouldn't apply but I applied it by hand. It works fine.

Ok. I will submit a patch. Thanks for the report and testing.


> 
> I didn't know about the CONFIG_SYSFS_DEPRECIATED options. Unfortunately I can't
> upgrade to FC9 or FC10 because of a kernel nfs bug(s) [11061,11154]. I'm not
> sure if I could run FC10 with an older kernel, but things like the changes to
> sysfs shows it is best not to assume so!
> 

I did not mean to upgrade to all F10 or F9 - just the iscsi package in 
there. The code across them is the same more or less. F9 and F8 were the 
same for iscsi, so if you use:

http://mirrors.kernel.org/fedora/updates/9/x86_64.newkey/iscsi-initiator-utils-6.2.0.870-1.0.fc9.x86_64.rpm

(for i386 or ppc then swap the x86_64 refs for your arch) on F8 then you 
should be ok.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
