From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] [PATCH] helper function for retrieving scsi_cmd given host based block layer tag
Date: Tue, 3 Oct 2006 13:43:43 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC074A3FB2@AVEXCH1.qlogic.org>
References: <20061003191026.GU7778@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8454 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1030362AbWJCUno convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 16:43:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20061003191026.GU7778@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>



> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com]
> Sent: Tuesday, October 03, 2006 12:10 PM
> To: David Somayajulu
> Cc: linux-scsi@vger.kernel.org; Mike Christie; David Wagner
> Subject: Re: [RFC] [PATCH] helper function for retrieving scsi_cmd
given host based block layer tag
> 
> On Tue, Oct 03 2006, David Somayajulu wrote:
> > > From: linux-scsi-owner@vger.kernel.org
> > [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David C
> > > Somayajulu
> > > Sent: Friday, September 22, 2006 3:01 PM
> > > To: Jens Axboe
> > > Cc: James Bottomley; linux-scsi@vger.kernel.org; Mike Christie;
Doug
> > Maxey; David Wagner
> > > > I wonder if you are using the 'block' branch, not just the
master
> > > > branch? It seems to apply perfectly there, but that is just the
same
> > as
> > > > Linus' tree. So when you have cloned the block git repo, there
are a
> > > > number of branches you can work against. The main branch with
> > current
> > > > changes is the 'block' branch, that is what you want to be
making
> > > > patches against.
> > > >
> > > > I'll be away for the entire next week, so no rush on my end.
> > > >
> > > I think I got it right this time. Here it is.
> > > Thanks
> > > David Somayajulu
> > Jens,
> > I would appreciate if you can let me know if the last post of the
above
> > patch was acceptable.
> 
> The content and indentation looks good, but it doesn't apply to the
> current tree. Care to rediff it?
Thanks Jens. I will send this ASAP.

