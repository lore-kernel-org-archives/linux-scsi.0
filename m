From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/3] mpt fusion: Resending Code clean up patch
Date: Thu, 21 May 2009 19:46:40 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A2606EE@inbmail01.lsi.com>
References: <20090417045258.GB19598@lsi.com>
 <1242847730.2881.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:51464 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZEUOQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 10:16:48 -0400
In-Reply-To: <1242847730.2881.76.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

This patch required all other pending patches to be applied first.
In any case I have to resend all other pending patches once again due to some committees went into Fusion driver in 2.6.30-rc6. I have to sync all pending patches with latest upstream. I am resending  all pending patches once again to synced with latest upstream kernel 2.6.30-rc6.

Thanks,
Kashyap


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, May 21, 2009 12:59 AM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 1/3] mpt fusion: Resending Code clean up patch

On Fri, 2009-04-17 at 10:22 +0530, Kashyap, Desai wrote:
> Resending patch considering Grants G's code review.
> 
> Main goal to submit this patch is code cleaup.
> 1. Better driver debug prints and code indentation.
> 2. fault_reset_work_lock is not used anywhere. driver is using taskmgmt_lock
> instead of fault_reset_work_lock.
> 3. setting pci_set_drvdata properly.
> 4. Ingore config request when IOC is in reset state.( ioc_reset_in_progress
> is set). 
> 5. Init/clear managment frame proprely.(INITIALIZE_MGMT_STATUS and
> CLEAR_MGMT_STATUS)

This isn't applying too well against scsi misc (which is identical to
Linus tree for the purposes of fusion).  Could you regenerate for either
of these trees, please?

patching file drivers/message/fusion/mptbase.c
Hunk #1 FAILED at 207.
Hunk #2 succeeded at 316 (offset -57 lines).
Hunk #3 succeeded at 1044 (offset 73 lines).
Hunk #4 succeeded at 1562 (offset -169 lines).
Hunk #5 FAILED at 1603.
Hunk #6 succeeded at 1842 (offset 50 lines).
Hunk #7 succeeded at 1644 (offset -165 lines).
Hunk #8 succeeded at 1935 (offset 50 lines).
Hunk #9 FAILED at 1986.
Hunk #10 succeeded at 1841 (offset -170 lines).
Hunk #11 succeeded at 2267 (offset 30 lines).
Hunk #12 succeeded at 2097 (offset -170 lines).
Hunk #13 succeeded at 2311 (offset 30 lines).
Hunk #14 succeeded at 2134 (offset -170 lines).
Hunk #15 succeeded at 2379 (offset 30 lines).
Hunk #16 succeeded at 2201 (offset -170 lines).
Hunk #17 succeeded at 2426 (offset 30 lines).
Hunk #18 succeeded at 2301 (offset -178 lines).
Hunk #19 succeeded at 2525 (offset 30 lines).
Hunk #20 succeeded at 2334 (offset -178 lines).
Hunk #21 succeeded at 2568 (offset 30 lines).
Hunk #22 succeeded at 2443 (offset -178 lines).
Hunk #23 succeeded at 2684 (offset 30 lines).
Hunk #24 succeeded at 2487 (offset -178 lines).
Hunk #25 succeeded at 2761 (offset 30 lines).
Hunk #26 succeeded at 2708 (offset -178 lines).
Hunk #27 succeeded at 2994 (offset 30 lines).
Hunk #28 succeeded at 2801 (offset -178 lines).
Hunk #29 succeeded at 3063 (offset 30 lines).
Hunk #30 succeeded at 2919 (offset -178 lines).
Hunk #31 succeeded at 3139 (offset 30 lines).
Hunk #32 succeeded at 2951 (offset -178 lines).
Hunk #33 succeeded at 3341 (offset 30 lines).
Hunk #34 succeeded at 3148 (offset -178 lines).
Hunk #35 succeeded at 3611 with fuzz 2 (offset 32 lines).
Hunk #36 succeeded at 3747 (offset -178 lines).
Hunk #37 succeeded at 3978 (offset 32 lines).
Hunk #38 succeeded at 3919 (offset -178 lines).
Hunk #39 succeeded at 4144 (offset 32 lines).
Hunk #40 succeeded at 4057 (offset -178 lines).
Hunk #41 succeeded at 4355 (offset 32 lines).
Hunk #42 succeeded at 4353 (offset -214 lines).
Hunk #43 succeeded at 5686 (offset 1 line).
Hunk #44 FAILED at 6153.
Hunk #45 succeeded at 5947 with fuzz 2 (offset -218 lines).
Hunk #46 succeeded at 6868 with fuzz 2 (offset 510 lines).
Hunk #47 FAILED at 7296.
Hunk #48 FAILED at 7329.
Hunk #49 FAILED at 7359.
Hunk #50 FAILED at 7413.
Hunk #51 succeeded at 6298 (offset -807 lines).
Hunk #52 succeeded at 7697 (offset 510 lines).
Hunk #53 succeeded at 6439 (offset -807 lines).
Hunk #54 succeeded at 7783 (offset 510 lines).
Hunk #55 succeeded at 6496 (offset -807 lines).
Hunk #56 succeeded at 7885 (offset 510 lines).
Hunk #57 succeeded at 6654 (offset -807 lines).
8 out of 57 hunks FAILED -- saving rejects to file
drivers/message/fusion/mptbase.c.rej
patching file drivers/message/fusion/mptbase.h
Hunk #1 FAILED at 76.
Hunk #3 succeeded at 162 (offset -1 lines).
Hunk #5 succeeded at 586 (offset -3 lines).
Hunk #6 succeeded at 702 (offset 3 lines).
Hunk #7 FAILED at 716.
Hunk #8 FAILED at 748.
Hunk #9 succeeded at 862 with fuzz 1 (offset -29 lines).
3 out of 9 hunks FAILED -- saving rejects to file
drivers/message/fusion/mptbase.h.rej
patching file drivers/message/fusion/mptctl.c
Hunk #1 succeeded at 2466 (offset -68 lines).
patching file drivers/message/fusion/mptsas.c
Hunk #1 succeeded at 434 (offset -290 lines).
Hunk #2 succeeded at 892 with fuzz 1 (offset -60 lines).
Hunk #3 succeeded at 1180 (offset -611 lines).
Hunk #4 succeeded at 1776 (offset -60 lines).
Hunk #5 succeeded at 1257 (offset -611 lines).
Hunk #6 FAILED at 1395.
Hunk #7 succeeded at 1962 with fuzz 2 (offset -60 lines).
Hunk #8 succeeded at 1433 (offset -611 lines).
Hunk #9 succeeded at 2000 (offset -60 lines).
Hunk #10 succeeded at 1513 (offset -611 lines).
Hunk #11 succeeded at 2226 (offset -60 lines).
Hunk #12 succeeded at 1715 (offset -611 lines).
Hunk #13 succeeded at 2298 (offset -60 lines).
Hunk #14 succeeded at 1795 (offset -611 lines).
Hunk #15 succeeded at 2382 (offset -60 lines).
Hunk #16 succeeded at 1866 (offset -611 lines).
Hunk #17 succeeded at 2642 (offset -60 lines).
Hunk #18 succeeded at 2118 (offset -611 lines).
Hunk #19 succeeded at 2977 with fuzz 1 (offset -464 lines).
1 out of 19 hunks FAILED -- saving rejects to file
drivers/message/fusion/mptsas.c.rej
patching file drivers/message/fusion/mptscsih.c
Hunk #2 succeeded at 292 (offset 57 lines).
Hunk #3 FAILED at 301.
Hunk #4 succeeded at 536 (offset 2 lines).
Hunk #5 succeeded at 654 (offset 57 lines).
Hunk #6 succeeded at 753 (offset 2 lines).
Hunk #7 succeeded at 994 (offset 57 lines).
Hunk #8 succeeded at 1000 (offset 2 lines).
Hunk #9 succeeded at 1350 (offset 57 lines).
Hunk #10 succeeded at 1305 (offset 2 lines).
Hunk #11 succeeded at 1845 (offset 133 lines).
Hunk #12 succeeded at 1737 with fuzz 1.
Hunk #13 succeeded at 1926 (offset 138 lines).
Hunk #14 FAILED at 1984.
Hunk #15 succeeded at 1875 (offset -4 lines).
Hunk #16 FAILED at 1896.
Hunk #17 succeeded at 2471 (offset 217 lines).
Hunk #18 succeeded at 2261 (offset -4 lines).
Hunk #19 succeeded at 2555 (offset 217 lines).
Hunk #20 FAILED at 2664.
4 out of 20 hunks FAILED -- saving rejects to file
drivers/message/fusion/mptscsih.c.rej
patching file drivers/message/fusion/mptscsih.h
Hunk #1 succeeded at 89 (offset -1 lines).

James


