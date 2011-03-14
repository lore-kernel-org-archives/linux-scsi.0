From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] AACRAID driver update patch version - 28000
Date: Mon, 14 Mar 2011 18:57:25 -0500
Message-ID: <1300147045.5665.8.camel@mulgrave.site>
References: <340C71CD25A7EB49BFA81AE8C8392667104CE89A@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44960 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab1COBiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 21:38:17 -0400
In-Reply-To: <340C71CD25A7EB49BFA81AE8C8392667104CE89A@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com

On Fri, 2011-03-11 at 05:01 -0800, Mahesh Rajashekhara wrote:
> Hi James,
> 
> The existing "aacraid" driver in the upstream kernel tree supports up to
> Series-5 controller (3GB/Sec) family.
> We launched Series-6 family of RAID controllers (6GB/Sec).
> 
> The new Series-6 adapters has PMC-Sierra's advanced ROC(RAID-on-chip)
> silicon.

OK, so this is line wrapped and won't apply.  Probably because you're
using outlook:  I think microsoft specifically programmed it to mangle
patch attachments.

If you can't use an email tool which can be made to work

Documentation/email-clients.txt

you'll need to attach the patches rather than inlining them (which will
annoy people).

> Patch description:
> ------------------
> Added new hardware device interface for PMC-Sierra's SRC based
> controller family.

This is a bit terse for a description.  It looks like you've added
support for the new device 0x28b which requires an expansion of the
doorbell registers to function?

> Please review the driver patch and let us know your comments.
> 
> Please see the patch below.
> 
> Thanks & Regards,
> Mahesh
> Linux Driver Development Engineer,
> PMC-Sierra ODC, Bangalore

OK, so really you want patch description first, then a set of three
dashes, then the rest of this (including the diffstat).  The automated
tools ignore all text after the '---' line, so anything that's not
description can go there.

James

P.S. can you take Mark Salyzyn's comments into account on the resend,
please?


