From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 09/13] scsi: in scsi_prep_fn(), remove bogus comments & clean up
Date: Fri, 1 Apr 2005 14:29:42 +0900
Message-ID: <20050401052942.GH11318@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.B562915C@htj.dyndns.org> <1112292140.5619.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.200]:31162 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262635AbVDAF3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 00:29:49 -0500
Received: by rproxy.gmail.com with SMTP id j1so563872rnf
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 21:29:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1112292140.5619.26.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

 Hello, James.

On Thu, Mar 31, 2005 at 12:02:20PM -0600, James Bottomley wrote:
> On Thu, 2005-03-31 at 18:08 +0900, Tejun Heo wrote:
> > -	 * come up when there is a medium error.  We have to treat
> > -	 * these two cases differently.  We differentiate by looking
> > -	 * at request->cmd, as this tells us the real story.
> > +	 * come up when there is a medium error.
> 
> This comment isn't wrong.  That's exactly what this piece of code:
> 
> 		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
> 
> is all about ... that's how it distinguishes between the two cases.
> 
> The comment is misleading --- what it actually should say is that req-
> >special has different contents depending upon the two cases, so
> rephrasing it to be more accurate would be helpful.

 Yes, it was misleading, even more so with previous REQ_SPECIAL
patches.  I'll rewrite the comment once we resolve the REQ_SPECIAL
issue.

 Thanks.

-- 
tejun

