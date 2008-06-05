From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/25] libiscsi: rename iscsi_cmd_task to iscsi_task
Date: Thu, 05 Jun 2008 09:53:00 -0500
Message-ID: <1212677580.13549.25.camel@localhost.localdomain>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
	 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57208 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbYFEOxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 10:53:05 -0400
In-Reply-To: <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-05-21 at 15:54 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This is the second part of the iscsi task merging, and
> all it does it rename iscsi_cmd_task to iscsi_task and
> mtask/ctask to just task.

OK, I've rebased the scsi-misc tree up to 2.6.26-rc5 (which includes the
rc-fixes tree) and I still can't get this to apply:

patching file drivers/scsi/libiscsi.c
Hunk #4 FAILED at 197.
Hunk #8 FAILED at 301.
Hunk #9 FAILED at 320.
Hunk #10 FAILED at 362.
Hunk #11 FAILED at 413.
Hunk #12 FAILED at 437.
Hunk #13 FAILED at 451.
Hunk #14 FAILED at 481.
Hunk #15 FAILED at 501.
Hunk #16 FAILED at 549.
Hunk #17 succeeded at 606 (offset -16 lines).
Hunk #18 FAILED at 634.
Hunk #19 FAILED at 650.
Hunk #20 FAILED at 696.
Hunk #21 FAILED at 742.
Hunk #22 FAILED at 792.
Hunk #23 FAILED at 802.
Hunk #24 FAILED at 822.
Hunk #25 succeeded at 903 with fuzz 1 (offset 46 lines).
Hunk #26 FAILED at 926.
Hunk #27 FAILED at 938.
Hunk #28 succeeded at 854 (offset -55 lines).
Hunk #29 FAILED at 902.
Hunk #30 FAILED at 955.
Hunk #31 FAILED at 968.
Hunk #32 succeeded at 1106 (offset 66 lines).
Hunk #33 succeeded at 1017 (offset -55 lines).
Hunk #34 succeeded at 1191 (offset 66 lines).
Hunk #35 FAILED at 1259.
Hunk #36 FAILED at 1404.
Hunk #37 FAILED at 1447.
Hunk #38 succeeded at 1340 (offset -55 lines).
Hunk #39 FAILED at 1433.
Hunk #40 FAILED at 1457.
Hunk #41 FAILED at 1483.
Hunk #42 succeeded at 1621 (offset 66 lines).
Hunk #43 succeeded at 1535 (offset -55 lines).
Hunk #44 FAILED at 1555.
Hunk #45 FAILED at 1567.
Hunk #46 succeeded at 1705 (offset 66 lines).
Hunk #47 succeeded at 1597 (offset -55 lines).
Hunk #48 succeeded at 1726 (offset 66 lines).
Hunk #49 FAILED at 1773.
Hunk #50 FAILED at 1954.
Hunk #51 FAILED at 1962.
Hunk #52 FAILED at 1970.
Hunk #53 FAILED at 2007.
Hunk #54 FAILED at 2103.
Hunk #55 FAILED at 2186.
Hunk #56 FAILED at 2267.
Hunk #57 FAILED at 2314.
39 out of 57 hunks FAILED -- saving rejects to file
drivers/scsi/libiscsi.c.rej
patching file include/scsi/libiscsi.h
Hunk #1 succeeded at 104 (offset 12 lines).
Hunk #2 succeeded at 119 (offset -1 lines).
Hunk #3 FAILED at 150.
Hunk #4 FAILED at 166.
Hunk #5 succeeded at 297 with fuzz 2 (offset 12 lines).
Hunk #6 FAILED at 377.
3 out of 6 hunks FAILED -- saving rejects to file
include/scsi/libiscsi.h.rej
patching file include/scsi/scsi_transport_iscsi.h
Hunk #1 FAILED at 33.
Hunk #2 FAILED at 112.
2 out of 2 hunks FAILED -- saving rejects to file
include/scsi/scsi_transport_iscsi.h.rej

James


