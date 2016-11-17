From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 07/15] scsi: fc: implement kref backed reference
 counting
Date: Thu, 17 Nov 2016 13:23:04 +0100
Message-ID: <42b4cf88-054d-23f1-68f0-cb713f80227b@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
 <8285c9478c568b2bb9f0f61da2953026058afa0c.1479374720.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54093 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753528AbcKQOdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 09:33:54 -0500
In-Reply-To: <8285c9478c568b2bb9f0f61da2953026058afa0c.1479374720.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On 11/17/2016 10:31 AM, Johannes Thumshirn wrote:
> Implement kref backed reference counting instead of rolling our own. This
> elimnates the need of the following fields in 'struct fc_bsg_job':
> * ref_cnt
> * state_flags
> * job_lock
> bringing us close to unification of 'struct fc_bsg_job' and 'struct bsg_job'.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_transport_fc.c | 40 +++++++++++-----------------------------
>  include/scsi/scsi_transport_fc.h |  4 +---
>  2 files changed, 12 insertions(+), 32 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
