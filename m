From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: Re: IO buffer alignment for block devices
Date: Mon, 13 Sep 2004 18:16:47 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4145B9DF.7020408@il.marvell.com>
References: <41459729.5060106@il.marvell.com> <1095084876.1762.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:20702 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S268670AbUIMPQ5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 11:16:57 -0400
In-Reply-To: <1095084876.1762.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>



James Bottomley wrote:

>On Mon, 2004-09-13 at 08:48, Saeed Bishara wrote:
>  
>
>>    Is there any minimal alignment for the IO buffers (sg and single) 
>>sent to a scsi LLD?
>>    I found that buffers that come from buffer cache, page cache and sg 
>>are page aligned , and the raw driver send sector aligned     buffers.
>>    so can I assume that the minimal alignment of the buffer is 512 bytes?
>>    
>>
>
>You can assume it will be whatever you set blk_queue_dma_alignment() to
>in your slave configure routines.  If the LLD doesn't set this, then it
>will be 8 bytes.  However, beware, setting this higher can cause user
>  
>
    isn't the default 512, this is what I see in blk_queue_make_request.

<http://lxr.linux.no/ident?v=2.6.8.1;i=blk_queue_make_request>

>generated commands to be errored if they fail the alignment checks.
>
>James
>
>  
>
any Ideas about lk 2.4?

>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

