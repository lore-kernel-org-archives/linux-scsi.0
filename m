From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Requested changes for the SCSI error handler
Date: 08 Jun 2004 11:26:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086711994.2105.18.camel@mulgrave>
References: <1086122775.2061.87.camel@mulgrave>
	<Pine.LNX.4.44L0.0406041655550.843-100000@ida.rowland.org>
	<20040604232344.GA3214@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:6045 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265245AbUFHQ0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 12:26:53 -0400
In-Reply-To: <20040604232344.GA3214@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-06-04 at 18:23, Mike Anderson wrote:
> Looks ok. I know your patch is in line with James requests, but I had a
> counter idea that allows for setting the settle delays up, down, or to
> zero post scsi_host_alloc. If the LLDD does nothing behavior should not
> change. This would allow increasing settle if some LLDD wanted it and
> also set it through sysfs if we wanted that in the future.  You can
> throw this patch in the bit bucket if you want to go the previously
> stated direction.

Well, how about a compromise?  I like the ability to alter the host
settle time; however, I think turning these over to the driver to sort
out how it pleases gives the LLD more control in this situation,
certainly for the HOST reset.

I'm less sure that a bus reset timeout belongs in the LLD, but I suppose
that could be pulled into the SPI transport class eventually.

So, what about Alan's approach using a single flag to give the LLD
control, but give it control for both the host and bus resets?

James


