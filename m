From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Thu, 9 Feb 2017 07:45:08 +0100
Message-ID: <cfc3f73b-a24e-b518-28b6-09cdd2811a02@suse.de>
References: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
 <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
 <52f4f81e-2353-4da2-7ce9-a7cd7796e1f7@gmail.com>
 <20170208124754.GA23225@infradead.org>
 <5b0f8560-a1ca-1b9a-3951-96e251c7b1a9@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbdBIHEx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Feb 2017 02:04:53 -0500
In-Reply-To: <5b0f8560-a1ca-1b9a-3951-96e251c7b1a9@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@infradead.org>, James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On 02/08/2017 08:13 PM, James Smart wrote:
> 
> On 2/8/2017 4:47 AM, Christoph Hellwig wrote:
>> On Tue, Feb 07, 2017 at 06:32:30PM -0800, James Smart wrote:
>>> I realize I cut these in a silly way.  In the v1 patches, I had a big
>>> patch
>>> that I then cut into 6 parts, by file.  In the v2 patches, I tried to
>>> keep
>>> the patches as is, and address the comments in the respective patch the
>>> comment came from. Which resulted in 3/8 with an old reference, but
>>> patch
>>> 8/8 being the one that reverted this reverence. Sorry..  I'll recut and
>>> repost.
>> This whole split doesn't make sense - either the patches are logically
>> split, in which case they can be posted separately, or they belong
>> together in which case they should be sent together.  But the size
>> of them suggest to me they probably need to be broken down to logically
>> separate patches.
>>
>> And can you please switch to using git-send-email to send the patches
>> straight from a git branch?  There are lot of patch formatting issues
>> with the lpfc patches, and that should fix most of them instantly.
>>
> 
> Ok. I will see if they can be further split. I don't have a lot of hope
> beyond a couple splits. So, the resulting patches will be large.
> 
Unfortunate, but should be okay.
We've reviewed the bulk of the patches already, so we'll live with that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
