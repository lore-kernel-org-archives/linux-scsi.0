From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Requested changes for the SCSI error handler
Date: Tue, 8 Jun 2004 14:31:29 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406081430220.649-100000@ida.rowland.org>
References: <1086711994.2105.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7684 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265284AbUFHSbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 14:31:32 -0400
In-Reply-To: <1086711994.2105.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 8 Jun 2004, James Bottomley wrote:

> Well, how about a compromise?  I like the ability to alter the host
> settle time; however, I think turning these over to the driver to sort
> out how it pleases gives the LLD more control in this situation,
> certainly for the HOST reset.
> 
> I'm less sure that a bus reset timeout belongs in the LLD, but I suppose
> that could be pulled into the SPI transport class eventually.
> 
> So, what about Alan's approach using a single flag to give the LLD
> control, but give it control for both the host and bus resets?

Sorry to appear slow... but isn't that exactly what my patch did?

Alan Stern

