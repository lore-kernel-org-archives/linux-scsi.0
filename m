From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] hpsa: add support for legacy boards
Date: Wed, 9 Aug 2017 17:08:05 +0200
Message-ID: <a20e126e-4738-aac2-a92e-71a448176c51@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-3-git-send-email-hare@suse.de>
 <20170809134112.GB25852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752592AbdHIPIH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 11:08:07 -0400
In-Reply-To: <20170809134112.GB25852@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/09/2017 03:41 PM, Christoph Hellwig wrote:
> On Tue, Aug 08, 2017 at 10:35:11AM +0200, Hannes Reinecke wrote:
>> Add support for legacy boards, ensuring to enable the driver for
>> those boards only when 'hpsa_allow_any' is set.
> 
> Why the wildcard instead of the specific IDs from the cciss driver?
> 
Because I'm lazy? And we're catching those boards with the wildcard
entry anyway? And the distinction between wildcard entry (designed to
catch unsupported devices) and pci IDs from the cciss drivers (which
will be unsupported, too) is meaningless?

But if you insist ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
