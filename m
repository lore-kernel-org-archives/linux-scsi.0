From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Wed, 14 Jun 2006 14:03:55 -0500
Message-ID: <44905D9B.6090701@cs.wisc.edu>
References: <20060610160815.GA12034@lst.de>	<20060612191948.GA8926@lst.de>	<1150253029.22961.4.camel@mulgrave.il.steeleye.com> <200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50335 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750795AbWFNTEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 15:04:07 -0400
In-Reply-To: <200606141843.k5EIhVks023235@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, hch@lst.de, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
> Date: Tue, 13 Jun 2006 21:43:49 -0500
> 
>> On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
>>> looks like no one but James looked at it as I attached a completely
>>> different patch that has been merged long ago.  Here's the real one:
>> And finally, the scsi-target-2.6 tree likewise needs converting.  This
>> one I'm not sure about, since they appear to need the copy from
>> cmnd_data to cmnd which I just killed.  Can someone who knows this tree
>> look this over?
> 
> Thanks for the patch.
> 
> tgt uses request_bufflen, bufflen, request_buffer, buffer to handle
> very large requests (that involves multiple bios). We can add
> substitutes into tgt specific data structure (scsi_tgt_cmd structure).
> 

I think that is going to be best since we are the only users now.

> I sent a patch related with scsi_tgt_cmd structure last week.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114960851929878&w=2
> 
> Will this patch be merged? I like to send a new patch on the top of
> it.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

