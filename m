From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Wed, 06 Aug 2014 13:37:03 +0000
Message-ID: <bug-80711-11613-StYrFquorR@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56216 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaHFNhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 09:37:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 63E9720160
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 13:37:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4A30420138
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2014 13:37:05 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #4 from d gilbert <dgilbert@interlog.com> ---
On 14-07-29 05:57 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=80711
>
> Alan <alan@lxorguk.ukuu.org.uk> changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |alan@lxorguk.ukuu.org.uk
>              Summary|SG_FLAG_LUN_INHIBIT is no   |[PATCH]SG_FLAG_LUN_INHIBIT
>                     |longer implemented and      |is no longer implemented
>                     |there's not way to prevent  |and there's not way to
>                     |the kernel from using the   |prevent the kernel from
>                     |2nd cdb byte for the LUN    |using the 2nd cdb byte for
>                     |                            |the LUN
>
> --- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk> ---
> Patches need to go to the mailing list and/or maintainers. See
> Documentation/SubmittingPatches.

In my original rework of the sg driver (1998) it did what
was being requested in this patch. Then around 10 years ago
changes were added to the SCSI subsystem to strip this
capability from the sg driver. Since then about 5 attempts (my
guess) have been made to re-instate this capability, this
being the most recent.

The use case is almost always the same: specialized USB
storage devices. USB is not going away. Does anyone see
a change in "company" policy in this regard?


If not and since I'm told black lists and the like won't
work, my advice for the record is to use FreeBSD or Windows
for tools that need this capability.

Doug Gilbert

-- 
You are receiving this mail because:
You are the assignee for the bug.
