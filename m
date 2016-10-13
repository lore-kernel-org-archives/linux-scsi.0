From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 01/16] scsi: Get rid of struct fc_bsg_buffer
Date: Thu, 13 Oct 2016 11:01:41 +0200
Message-ID: <35e25d76-fca2-3747-62d6-b507852338ba@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <7d48b2abe199453b531e3bc6b560ea417d48d013.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44258 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752193AbcJMJOR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 05:14:17 -0400
In-Reply-To: <7d48b2abe199453b531e3bc6b560ea417d48d013.1476276823.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> struct fc_bsg_buffer is just a clone of struct bsg_buffer from bsg-lib,
> so use this one instead.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c     |  3 ++-
>  drivers/scsi/scsi_transport_fc.c |  2 +-
>  include/scsi/scsi_transport_fc.h | 12 +++---------
>  3 files changed, 6 insertions(+), 11 deletions(-)
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
