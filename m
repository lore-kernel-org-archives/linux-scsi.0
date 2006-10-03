From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] helper function for retrieving scsi_cmd given host based block layer tag
Date: Tue, 3 Oct 2006 21:10:27 +0200
Message-ID: <20061003191026.GU7778@kernel.dk>
References: <1158962434.4040.35.camel@dcslnxpc.site> <0BB3E5E7462EEA4295BC02D49691DC074A3F84@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:53269 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1030478AbWJCTKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2006 15:10:53 -0400
Content-Disposition: inline
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC074A3F84@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

On Tue, Oct 03 2006, David Somayajulu wrote:
> > From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David C
> > Somayajulu
> > Sent: Friday, September 22, 2006 3:01 PM
> > To: Jens Axboe
> > Cc: James Bottomley; linux-scsi@vger.kernel.org; Mike Christie; Doug
> Maxey; David Wagner
> > > I wonder if you are using the 'block' branch, not just the master
> > > branch? It seems to apply perfectly there, but that is just the same
> as
> > > Linus' tree. So when you have cloned the block git repo, there are a
> > > number of branches you can work against. The main branch with
> current
> > > changes is the 'block' branch, that is what you want to be making
> > > patches against.
> > >
> > > I'll be away for the entire next week, so no rush on my end.
> > >
> > I think I got it right this time. Here it is.
> > Thanks
> > David Somayajulu
> Jens,
> I would appreciate if you can let me know if the last post of the above
> patch was acceptable.

The content and indentation looks good, but it doesn't apply to the
current tree. Care to rediff it?

-- 
Jens Axboe

