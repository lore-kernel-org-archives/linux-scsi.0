From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Thu,  6 Nov 2008 06:58:24 -0800 (PST)
Message-ID: <20081106145824.57883108058@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYKFO7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 09:59:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6EwOIb007052
	for <linux-scsi@vger.kernel.org>; Thu, 6 Nov 2008 06:58:25 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #26 from anonymous@kernel-bugs.osdl.org  2008-11-06 06:58 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-11-05 at 18:19 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> ------- Comment #25 from yanmin_zhang@linux.intel.com  2008-11-05 18:19 -------
> Created an attachment (id=18697)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=18697&action=view)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=18697&action=view)
> Here is the patch to fix it against 2.6.28-rc3.
> 
> I tested the patch on my 2 machines and it does fix the issue.

The problem is that it doesn't fix the theoretical tight loop, so
someone else will run into the issue under more trying circumstances.

The only reason a patch which conditionally NULLs starved_head works
over one that does it absolutely should be that there's some other loop
that requires it being set to effect a break out.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
