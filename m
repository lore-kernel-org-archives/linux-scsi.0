From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/6] libata: factor out a ata_log_supported helper
Date: Tue, 6 Jun 2017 08:28:00 +0200
Message-ID: <3f8b6db3-a128-094c-850e-d8889db245a8@suse.de>
References: <20170604124225.27032-1-hch@lst.de>
 <20170604124225.27032-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47364 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750734AbdFFG2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jun 2017 02:28:07 -0400
In-Reply-To: <20170604124225.27032-3-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/04/2017 02:42 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/ata/libata-core.c | 59 +++++++++++++----------------------------------
>  1 file changed, 16 insertions(+), 43 deletions(-)
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
