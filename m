From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] libfc: don't assign resid_len in fc_lport_bsg_request
Date: Wed, 4 Oct 2017 08:17:14 +0200
Message-ID: <341172a3-1444-b368-9f5c-1c94b8f413f0@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-4-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> bsg_job_done takes care of updating the scsi_request structure fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libfc/fc_lport.c | 3 ---
>  1 file changed, 3 deletions(-)
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
