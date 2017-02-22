From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Wed, 22 Feb 2017 10:06:36 +0100
Message-ID: <6003dda1-bc9c-5004-d901-c4af5cb075e7@suse.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
 <1487680029-3701-2-git-send-email-hare@suse.de>
 <20170222082841.GA22843@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754464AbdBVJGl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 04:06:41 -0500
In-Reply-To: <20170222082841.GA22843@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/22/2017 09:28 AM, Christoph Hellwig wrote:
> Martin,
> 
> can we get at least this patch still in for 4.11?  I'd really like
> to see as many intance of the old MSI-X allocation and IRQ affinity
> mess dead as soon as possible.
> 
I'm currently reworking the patchset with the suggestions from
Christoph, will be posting the next iteration later today.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
