From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] hpsa: consolidate status variables
Date: Mon, 14 Aug 2017 12:02:45 +0200
Message-ID: <7785e641-1fa5-4d2f-c2e4-251d74c713fb@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-2-git-send-email-hare@suse.de>
 <20170809134030.GA25852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47342 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751403AbdHNKCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 06:02:48 -0400
In-Reply-To: <20170809134030.GA25852@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/09/2017 03:40 PM, Christoph Hellwig wrote:
> These seem to be modified from sysfs files, so you'll run into
> read-modify-write atomicy issues with bitfields.
> 
> That being said while plain ints are somewhat safe the right thing
> would be to use proper atomic bitops.
> 
True, but rewriting that into atomics would change the flow of the
driver by quite a bit (as quite some spinlocks can be removed),
so I'd rather _not_ attempt this now.

So I'll be dropping this patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
