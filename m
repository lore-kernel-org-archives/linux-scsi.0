From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 7 Feb 2017 16:49:08 +0100
Message-ID: <55ceab84-5327-80a8-b2c2-638c7d2affed@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170207131909.GH19247@lst.de>
 <eb606203-9adf-4200-ae1c-7f518342f863@suse.de>
 <20170207153446.GA22228@lst.de>
 <6e7b8750-a355-0607-875f-751a0f9fdae8@suse.de>
 <20170207154052.GA22384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754199AbdBGPtL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 10:49:11 -0500
In-Reply-To: <20170207154052.GA22384@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On 02/07/2017 04:40 PM, Christoph Hellwig wrote:
> On Tue, Feb 07, 2017 at 04:39:01PM +0100, Hannes Reinecke wrote:
>> But we do; we're getting the index/tag/smid from the high-priority list,
>> which is separated from the normal SCSI I/O tag space.
>> (which reminds me; there's another cleanup patch to be had in
>> _ctl_do_mpt_command(), but that's beside the point).
> 
> The calls to blk_mq_tagset_busy_iter added in patch 8 indicate the
> contrary.
> 
Right. Now I see what you mean.
We should have used reserved_tags here.
Sadly we still don't have an interface on actually _allocate_ reserved
tags, have we?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
