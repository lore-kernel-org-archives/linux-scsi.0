From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Requested changes for the SCSI error handler
Date: Tue, 8 Jun 2004 11:39:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608183905.GA1360@us.ibm.com>
References: <1086711994.2105.18.camel@mulgrave> <Pine.LNX.4.44L0.0406081430220.649-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:24742 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265284AbUFHSiz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 14:38:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0406081430220.649-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On 8 Jun 2004, James Bottomley wrote:
> 
> > Well, how about a compromise?  I like the ability to alter the host
> > settle time; however, I think turning these over to the driver to sort
> > out how it pleases gives the LLD more control in this situation,
> > certainly for the HOST reset.
> > 
> > I'm less sure that a bus reset timeout belongs in the LLD, but I suppose
> > that could be pulled into the SPI transport class eventually.
> > 
> > So, what about Alan's approach using a single flag to give the LLD
> > control, but give it control for both the host and bus resets?
> 
> Sorry to appear slow... but isn't that exactly what my patch did?

Yes. That is what I thought you sent. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

