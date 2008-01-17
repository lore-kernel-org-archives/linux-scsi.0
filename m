From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/8] scsi-drivers Don't use SG_ALL as allocation size
Date: Thu, 17 Jan 2008 10:30:56 -0800
Message-ID: <20080117183056.GA20884@plap3.qlogic.org>
References: <478F8435.5000907@panasas.com> <478F85E7.20503@panasas.com> <20080117174745.GB20186@plap3.qlogic.org> <478F9A6D.1010605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:41513 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbYAQSbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 13:31:05 -0500
Content-Disposition: inline
In-Reply-To: <478F9A6D.1010605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 17 Jan 2008, Boaz Harrosh wrote:

> > I don't forsee any issues with maintaining SG_ALL (~0) usage within
> > qla2xxx and qla4xxx, as the number of unused entries on the HBA's
> > request-queue shall ultimately be the rate-limiting factor.
> > 
> > --
> Please forgive me I have forgot to put the use of this constants at
> body, see patch below.
> 
> I have seen the use of a device memory at the scsi_for_each_sg loop and was
> not at all sure what is the size limit for that. So I played it safe,
> actually I changed nothing. Please give me the OK to remove ql[24]xxx from
> these patches,

I believe that's best, simply remove the qla2xxx/qla4xxx component
from your patchset.

Thanks, AV
