From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fusion problems on 64bit hosts
Date: Mon, 27 Sep 2004 23:23:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040927232354.A28919@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57050F84D0@exa-atlanta> <1096323650.2035.86.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:19219 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267388AbUI0WYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 18:24:02 -0400
Content-Disposition: inline
In-Reply-To: <1096323650.2035.86.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Sep 27, 2004 at 06:20:43PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Dean Moore <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Mon, Sep 27, 2004 at 06:20:43PM -0400, James Bottomley wrote:
> On Mon, 2004-09-27 at 18:12, Moore, Eric Dean wrote:
> > No, we are not keeping a 64bit pointer in a 32bit hardware register.
> > IMO we can solve this issue by adding ppc64 to define above.
> 
> Assuming this is the correct thing to do, what's wrong with predicating
> on 
> 
> #ifdef __LP64__

that's only defined for parisc and ia64. the correct thing is

#if BITS_PER_LONG == 64


but I don't like what you're doing here.  I'd rather see two callbacks for
different types of data.

