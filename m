From: Chris Wright <chrisw@osdl.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.12
Date: Sat, 18 Jun 2005 10:45:58 -0700
Message-ID: <20050618174558.GX9153@shell0.pdx.osdl.net>
References: <1119103586.4984.5.camel@mulgrave> <20050618141636.GA4112@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32917 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262163AbVFRRqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jun 2005 13:46:08 -0400
Content-Disposition: inline
In-Reply-To: <20050618141636.GA4112@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

* Christoph Hellwig (hch@infradead.org) wrote:
> > Andrew Vasquez:
> >   o qla2xxx: Pull-down scsi-host-addition to follow board initialization
> 
> Can we please put this one in 2.6.12.1?  qla2xxx breaks horribly in 2.6.12
> because this one is missing.

Sure, if it's seriously broken w/out send it to stable@kernel.org,
and we'll queue it up.

thanks,
-chris
