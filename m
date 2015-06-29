From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Mon, 29 Jun 2015 22:27:33 +0000
Message-ID: <bug-98171-11613-ENzQpmuA1w@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbF2W1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 18:27:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A645220600
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 22:27:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9FC9B20609
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 22:27:33 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

--- Comment #1 from nucrap@hotmail.com ---
> This is a regression against 3.14? There was only one change affecting
> mvsas between those kernels and that was the libsas change:
> 
> commit bc6e7c4b0d1a1f742d96556f63d68f17f4e232c3
> Author: Dan Williams <dan.j.williams@intel.com>
> Date: Fri Mar 14 13:52:48 2014 -0700
> 
> libata, libsas: kill pm_result and related cleanup
> 
> Does reverting that make the problem go away?
> 

It's a regression starting with linux 3.15, meaning everything still worked
with linux 3.14.
I have tried reverting that patch from linux-3.15.10 vanilla sources but it
fails... I don't know why, maybe I'm just not leet enough:

Hunk #1 succeeded at 5364 (offset 13 lines).
Hunk #2 succeeded at 5388 (offset 13 lines).
Hunk #3 FAILED at 5390.
Hunk #4 succeeded at 5506 (offset 13 lines).
Hunk #5 succeeded at 5532 (offset 13 lines).
1 out of 5 hunks FAILED -- saving rejects to file drivers/ata/libata-core.c.rej
patching file drivers/ata/libata-eh.c
patching file drivers/scsi/libsas/sas_ata.c
patching file include/linux/libata.h
Hunk #1 succeeded at 850 (offset 2 lines).
Hunk #2 FAILED at 1140.
1 out of 2 hunks FAILED -- saving rejects to file include/linux/libata.h.rej
patching file include/scsi/libsas.h
patch unexpectedly ends in middle of line
Hunk #1 succeeded at 172 with fuzz 1.


What shall I do?

Regards,

Philip

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
