From: Christoph Hellwig <hch@infradead.org>
Subject: Re: merge megaraid 2.20.x in kernel 2.6?
Date: Tue, 17 Aug 2004 17:47:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817174755.A23872@infradead.org>
References: <20040817160128.GA7127@lists.us.dell.com> <1092760835.1775.303.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:518 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266488AbUHQQsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:48:05 -0400
Content-Disposition: inline
In-Reply-To: <1092760835.1775.303.camel@mulgrave>; from James.Bottomley@SteelEye.com on Tue, Aug 17, 2004 at 12:40:33PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, atulm@lsil.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Aug 17, 2004 at 12:40:33PM -0400, James Bottomley wrote:
> On Tue, 2004-08-17 at 12:01, Matt Domsch wrote:
> > James, is there anything you're still waiting on before merging the
> > LSI megaraid 2.20.x driver into your scsi-misc-2.6 tree?  I thought
> > the agreement by you, Christoph, and Atul was to get it merged, and
> > then fix up the few outstanding concerns post-merge.
> 
> OK, I forgot in the rush of conferences.
> 
> I did put it in, but it fails to compile on parisc:
> 
> In file included from drivers/scsi/megaraid/megaraid_mm.c:18:
> drivers/scsi/megaraid/megaraid_mm.h:51:25: asm/ioctl32.h: No such file
> or directory

No one should use <asm/ioctl32.h> but always <linux/ioctl32.h>

> drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_init':
> drivers/scsi/megaraid/megaraid_mm.c:1069: warning: implicit declaration
> of function `register_ioctl32_conversion'
> drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_exit':
> drivers/scsi/megaraid/megaraid_mm.c:1098: warning: implicit declaration
> of function `unregister_ioctl32_conversion'

That should also fix this one I guess, not having the current source
tree near me.  Does this driver release have the queue removal James
wanted?

