From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Tue, 20 Jun 2006 16:49:34 +0900
Message-ID: <20060620164934S.fujita.tomonori@lab.ntt.co.jp>
References: <20060612191948.GA8926@lst.de>
	<1150253029.22961.4.camel@mulgrave.il.steeleye.com>
	<200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:7348 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965132AbWFTHtq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 03:49:46 -0400
In-Reply-To: <200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: James.Bottomley@SteelEye.com, hch@lst.de, linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Thu, 15 Jun 2006 03:43:26 +0900

> From: James Bottomley <James.Bottomley@SteelEye.com>
> Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
> Date: Tue, 13 Jun 2006 21:43:49 -0500
> 
> > On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
> > > looks like no one but James looked at it as I attached a completely
> > > different patch that has been merged long ago.  Here's the real one:
> > 
> > And finally, the scsi-target-2.6 tree likewise needs converting.  This
> > one I'm not sure about, since they appear to need the copy from
> > cmnd_data to cmnd which I just killed.  Can someone who knows this tree
> > look this over?
> 
> Thanks for the patch.
> 
> tgt uses request_bufflen, bufflen, request_buffer, buffer to handle
> very large requests (that involves multiple bios). We can add
> substitutes into tgt specific data structure (scsi_tgt_cmd structure).
> 
> I sent a patch related with scsi_tgt_cmd structure last week.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2
> 
> Will this patch be merged? I like to send a new patch on the top of
> it.

Hi James,

The 'update for cmnd field removal' patch got merged but the patch
refereed to in this mail did not. Did you just forget or you don't
like it?
