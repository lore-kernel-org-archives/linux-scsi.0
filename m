From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: Re: can_queue modification within select_queue_depths
Date: Thu, 19 Aug 2004 14:58:38 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412495EE.1000904@il.marvell.com>
References: <41233AB1.7030605@il.marvell.com> <20040819121902.A8273@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:50831 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S265768AbUHSL6z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 07:58:55 -0400
In-Reply-To: <20040819121902.A8273@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

yes I'm working on Marvells sata devices, I'm still waiting for Jeff for 
an initial libata version.


Christoph Hellwig wrote:

>On Wed, Aug 18, 2004 at 02:17:05PM +0300, Saeed Bishara wrote:
>  
>
>>Hi,
>>    is it allowed to modify the host can_queue with select_queue_depths 
>>function?
>>    
>>
>
>Yes.
>
>  
>
>>    if yes, is it needed to lock/unlock io_request_lock ?
>>thanks  
>>    
>>
>
>Dunno about 2.4 locking, but given this is at init time and thus implicitly
>serialized I wouldn't care too much about locking.
>
>
>BTW, if you happen to work on a driver for the marvell SATA part please
>talk to Jeff Garzik who is doing a libata driver for it.  Also note that
>we're not going to accept pure SCSI LLDDs for (S)ATA hardware.
>
>  
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>


