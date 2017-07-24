From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/28] visorhba: sanitze private device data allocation
Date: Mon, 24 Jul 2017 11:28:27 +0200
Message-ID: <a19603b2-4c41-87be-535b-bd7b9914f906@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
 <1498638316-44420-27-git-send-email-hare@suse.de>
 <CY4PR07MB3176109C5BDB7B51AD3BB73FF0A60@CY4PR07MB3176.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37171 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752579AbdGXJ2a (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 05:28:30 -0400
In-Reply-To: <CY4PR07MB3176109C5BDB7B51AD3BB73FF0A60@CY4PR07MB3176.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kershner, David A" <David.Kershner@unisys.com>
Cc: "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/19/2017 07:45 PM, Kershner, David A wrote:
> 
> 
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Wednesday, June 28, 2017 4:25 AM
>> To: Christoph Hellwig <hch@lst.de>
>> Subject: [PATCH 26/28] visorhba: sanitze private device data allocation
>>
>> There's no need to keep the private data for a device in a separate
>> list; better to store it in ->hostdata and do away with the additional
>> list.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Cc: David Kershner <david.kershner@unisys.com>
> 
> I'm not sure what the process for this patch was to get into the upstream, do
> you know the forecast for it? I.e. when it will be available in Linus's tree? 
> 
> We have several more changes that I would like to make to this driver and
> to simplify them, I would like to put them on top of this change, would you
> mind if I submitted it to GregKH for the staging branch if it is going to take
> some time?
> 
> Sorry for the newbie questions.
> 
typically the maintainer (that'll be you :-) does a review, and replies
with something like:

Patch is okay;

Reviewed-by: David Kershner <XXX@YYY.com>

Then the subsystem maintainer (ie Martin Petersen) will be picking it
up, and queueing it in his subsystem tree for eventual merge with linux
upstream.

The first step has been completed, so we're waiting for Martin to pick
it up. It might be some time, though; depending on the merge window and
his overall workload.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
