From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sat, 29 Jan 2005 19:40:29 -0600
Message-ID: <1107049229.4535.38.camel@mulgrave>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap>
	 <1107017081.4535.29.camel@mulgrave>  <20050129193421.GA7573@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22934 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261627AbVA3Bku (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 20:40:50 -0500
In-Reply-To: <20050129193421.GA7573@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:
> But the transport hit a failure, not the storage device.
> 
> I thought Andrew hit this sequence:
> 
> 	- pull / replace cable
> 
> 	- IO resumes but gets NOT_READY (the device could be logging back
> 	  into the fibre or such)
> 
> 	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
> 	  scmd->retries has already been exhausted by the NOT_READY
> 
> Did I misread something?

Erm, not sure.  Perhaps I'm confused.  I thought it was the *device*
that had responded NOT_READY.  Obviously, if it's the driver
manufacturing NOT_READY sense because of some transport condition, then
it needs to be correctly reported as a DID_...

James


