From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SCSI git trees
Date: Tue, 4 Aug 2009 22:36:29 +0200
Message-ID: <20090804203629.GM12579@kernel.dk>
References: <1248887256.3900.78.camel@mulgrave.site> <19063.9181.620137.814464@stoffel.org> <1249325826.3943.207.camel@mulgrave.site> <19063.14027.208148.82667@stoffel.org> <20090803202731.GR12579@kernel.dk> <19063.20434.94571.192897@stoffel.org> <20090803210426.GY12579@kernel.dk> <19064.25541.671065.230388@stoffel.org> <20090804201544.GK12579@kernel.dk> <19064.39373.825924.246068@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:50728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbZHDUg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Aug 2009 16:36:29 -0400
Content-Disposition: inline
In-Reply-To: <19064.39373.825924.246068@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 04 2009, John Stoffel wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> On Tue, Aug 04 2009, John Stoffel wrote:
> >> 
> >> Hi Jens,
> >> 
> >> I've just sent you a copy of the patch, to both axboe@kernel.dk and
> >> this address.  Let me know if you want me to re-spin it or not.
> 
> Jens> I've applied it, as I wrote in the other email. You probably
> Jens> want to check the arch defconfigs though, to see if they enable
> Jens> it by default.  Since the symbol already exists, the default y
> Jens> will have little impact on what people compiling their own
> Jens> kernels get to select.
> 
> Thanks for applyging this.  I'll take a look at the deconfigs and see
> if any changes need to be made.  

It doesn't look too bad. And x86 and x86-64 already have BSG as y in the
defconfigs, so it should be quite wide spread already. So I'd say we are
fine now.

-- 
Jens Axboe

