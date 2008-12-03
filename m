From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Wed,  3 Dec 2008 02:19:00 -0800 (PST)
Message-ID: <20081203101900.93B90108040@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbYLCKTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 05:19:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB3AJ0Nw014214
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 02:19:01 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #8 from bs@q-leap.de  2008-12-03 02:19 -------
> Mike Anderson pointed out that we have a potential window where the
> timer can fire after we've unprepped the request in SCSI (so making
> req->special NULL) but before we call blk_requeue_request() which stops
> the timer.  We can rejig the locking to prevent this from happening, so
> could you (separately) try this patch?
> 
> James
> 

Hello James,

sorry for the huge delay. Unfortunately it turned out I was just 'lucky' to run
into this bug the first few times. When I later on tried to reproduce this
specific issue, I tried 20 times and couldn't, even without any patch :( So
testing especially the 2nd patch turnes out to be a bit difficult (can't be
verified by printk). 
I now also mostly only have remotely access to the test hardware and can't
reset this system remotely, so testing has become a bit difficult :(
Tomorrow will be in the lab again and try to test again.

Thanks for your help and patience,
Bernd


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
