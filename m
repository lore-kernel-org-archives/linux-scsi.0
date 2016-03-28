From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v2
Date: Mon, 28 Mar 2016 14:26:27 -0700
Message-ID: <56F9A183.5060405@sandisk.com>
References: <564F9AFF.3050605@sandisk.com>
 <20151124231331.GA25591@infradead.org> <5654F169.6070000@sandisk.com>
 <20151125084744.GA16429@infradead.org> <5655CCC0.9010107@sandisk.com>
 <yq1610jf0jk.fsf@sermon.lab.mkp.net> <565CF57A.4090507@sandisk.com>
 <20151201072315.GA12183@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:37760
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252AbcC1V0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:26:33 -0400
In-Reply-To: <20151201072315.GA12183@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/30/2015 11:23 PM, Christoph Hellwig wrote:
> On Mon, Nov 30, 2015 at 05:18:50PM -0800, Bart Van Assche wrote:
>> Since the original patch caused a regression, please proceed with reverting
>> the original patch.
>>
>> Regarding this patch: is there anyone on the CC-list of this e-mail who can
>> review it ?
>
> I'm not too fond of the approach.  I'd much prefer if SCSI would just
> release the dev_t later, similar to DM or MD.

(replying to an e-mail of four months ago)

Hello Christoph,

Sorry that it took so long but last week I finally found the time to 
look further into this. I will post a third version of this patch.

Bart.

