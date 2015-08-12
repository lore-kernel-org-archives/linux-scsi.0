From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] fnic: check pci_map_single() return value
Date: Wed, 12 Aug 2015 13:56:40 +0200
Message-ID: <55CB3478.7060200@redhat.com>
References: <1439371208-19841-1-git-send-email-mlombard@redhat.com> <mqdr3n8ybqt.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbbHLL4n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 07:56:43 -0400
In-Reply-To: <mqdr3n8ybqt.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, jbottomley@parallels.com

Hi Johannes,

On 08/12/2015 01:42 PM, Johannes Thumshirn wrote:
> hmmm, how about
> 
> goto free_skb;
>> +	}
>> +
>>  	fnic_queue_rq_desc(rq, skb, pa, len);
>> -	return 0;
>> +err:
> 
> free_skb:
>         kfree_skb(skb);
> 
>> +	return r;
>>  }
> 
> Although the return is near to the error handling, it's preferred to
> have the labels named after the action that is taken there.

Ok, I'll post a V2 of this patch soon, thanks for the review.

Regards,
Maurizio Lombardi
