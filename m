From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11804] iscsi: LRO plus iSCSI causes panic
Date: Thu,  6 Nov 2008 16:29:55 -0800 (PST)
Message-ID: <20081107002955.227A4108043@picon.linux-foundation.org>
References: <bug-11804-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYKGAa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 19:30:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA70TtnV018310
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2008 16:29:56 -0800
In-Reply-To: <bug-11804-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11804





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-11-06 16:29 -------
Reply-To: akpm@linux-foundation.org

On Thu, 6 Nov 2008 16:08:08 -0800
"Brandeburg, Jesse" <jesse.brandeburg@intel.com> wrote:

> Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via
> > the bugzilla web interface).
> 
> This panic is still unaddressed.

It looks like we own it :(

>  Can I provide more information?
> 
> >> http://bugzilla.kernel.org/show_bug.cgi?id=11804

I guess it would be useful to use addr2line or gdb or whatever to work
out exactly which statement is faulting, which pointer contains the
garbage value, etc.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
