From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 15/16] scsi: fc: move FC transport's bsg code to
 bsg-lib
Date: Thu, 13 Oct 2016 13:49:50 +0200
Message-ID: <95dd831f-a276-c336-010c-bd3794e023e3@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <65886ca677259889fff0ad31efd081401349ebdc.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754198AbcJMLvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 07:51:53 -0400
In-Reply-To: <65886ca677259889fff0ad31efd081401349ebdc.1476276823.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Now that all conversions are done, move the FibreChannel bsg code over to the
> bsg library. Note that CONFIG_SCSI_FC_ATTRS now needs to select BLK_DEV_BSGLIB
> in order to build correctly.
> 
> This patch is derived from work done by Mike Christie in 2011 [1] but only the
> iscsi parts got merged back then.
> 
> [1] http://marc.info/?l=linux-scsi&m=131149780921009&w=2
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/Kconfig             |   1 +
>  drivers/scsi/scsi_transport_fc.c | 287 ++++++---------------------------------
>  2 files changed, 44 insertions(+), 244 deletions(-)
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
