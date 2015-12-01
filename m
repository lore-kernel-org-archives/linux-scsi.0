From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Mon, 30 Nov 2015 17:18:50 -0800
Message-ID: <565CF57A.4090507@sandisk.com>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org> <5654F169.6070000@sandisk.com>
 <20151125084744.GA16429@infradead.org> <5655CCC0.9010107@sandisk.com>
 <yq1610jf0jk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0077.outbound.protection.outlook.com ([65.55.169.77]:21584
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbbLABSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 20:18:55 -0500
In-Reply-To: <yq1610jf0jk.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-mm@kvack.org

On 11/30/2015 04:57 PM, Martin K. Petersen wrote:
>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
>
> Bart> This race is hard to trigger. I can trigger it by repeatedly
> Bart> removing and re-adding SRP SCSI devices. Enabling debug options
> Bart> like SLUB debugging and kmemleak helps. I think that is because
> Bart> these debug options slow down the SCSI device removal code and
> Bart> thereby increase the chance that this race is triggered.
>
> Any updates on this? Your updated patch has no reviews.
>
> Should I just revert the original patch for 4.4?

Hello Martin,

Since the original patch caused a regression, please proceed with 
reverting the original patch.

Regarding this patch: is there anyone on the CC-list of this e-mail who 
can review it ?

Thanks,

Bart.
