From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2 1/2] tcm: Add support for BIDI-COMMANDS and XDWRITE_READ_10
 emulation
Date: Sun, 19 Sep 2010 15:35:11 +0200
Message-ID: <4C96118F.8080909@panasas.com>
References: <1284590512-6233-1-git-send-email-nab@linux-iscsi.org> <4C961044.3010500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:50071 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753732Ab0ISNfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Sep 2010 09:35:15 -0400
In-Reply-To: <4C961044.3010500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>

On 09/19/2010 03:29 PM, Boaz Harrosh wrote:
> On 09/16/2010 12:41 AM, Nicholas A. Bellinger wrote:
>>  		/* Fall through for DMA_TO_DEVICE */
>>  	case DMA_NONE:
>>  		CMD_TFO(cmd)->queue_status(cmd);
>> @@ -6347,6 +6460,23 @@ static inline void transport_free_pages(struct se_cmd *cmd)
>>  		kmem_cache_free(se_mem_cache, se_mem);
>>  	}
>>  
> 
> Again the request for an update tree. (Might be missing some code here)
> 
> The above does a break; in bidi case, but are you freeing this here regardless?
> 

Scratch this out stupid me. That's in another function. Rrrr I need my coffee now

Boaz
