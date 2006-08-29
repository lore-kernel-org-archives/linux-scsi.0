From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: timeout during sas discovery (aic94xx)
Date: Tue, 29 Aug 2006 11:22:52 -0500
Message-ID: <1156868572.3458.25.camel@mulgrave.il.steeleye.com>
References: <20060828231832.GA1037@us.ibm.com> <44F3D428.60705@us.ibm.com>
	 <1156859623.3458.3.camel@mulgrave.il.steeleye.com>
	 <20060829160307.GA11028@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56491 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965060AbWH2QW5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 12:22:57 -0400
In-Reply-To: <20060829160307.GA11028@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org, alexisb@us.ibm.com

On Tue, 2006-08-29 at 09:03 -0700, Mike Anderson wrote:
> I think this failure mode is a different path than what your patch tries to
> address. We sending a inquiry to the device and coming through the
> standard IO path and not through sas_execute_task.
> 
> I still think for these cases that we need to be running the patch I
> previous sent to the list to try and get the abort to work (this patch is
> not in the git tree so one needs to add this on top of the git source).
> This will not solve the timeout, but would at least address the tmf time
> out.

OK ... I was waiting for Adaptec to comment on that one since it's
messing with undocumented sequencer bits.  However, prove it works in
this case and I can put it in.

> We need to also address the first issue of the inquiry timeout. Previous
> runs showed that we where hitting this error a lot on the inquiry to the
> Vitesse SES device which the adp driver has created a work around (unclear
> if the work around solves the issue or not).

What is the work around?

James


