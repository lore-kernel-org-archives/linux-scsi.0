From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] hpsa: do not print errors for unsupported report luns
 format
Date: Wed, 9 Aug 2017 16:52:10 +0200
Message-ID: <90855545-0d7d-0213-8544-9273eda7163a@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-6-git-send-email-hare@suse.de>
 <20170809134616.GF25852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751722AbdHIOwM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 10:52:12 -0400
In-Reply-To: <20170809134616.GF25852@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/09/2017 03:46 PM, Christoph Hellwig wrote:
> I don't like the misnamed supported flag.  Either we should always ignore
> the errors, or key it off a specific flag for newer firmware.
> 
Well, there is no such hardware flag; there are several features
implemented across the board. Hence we need to store it in the driver
structure, which actually is the reason for the 'supported' flag.

I can rename it to 'legacy_board' or the like if 'supported' is not an
acceptable naming ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
