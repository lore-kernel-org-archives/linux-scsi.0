From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] bfa: don't reset max_segments for every bsg request
Date: Wed, 4 Oct 2017 08:16:44 +0200
Message-ID: <b74a1bab-a457-e0af-3c9d-b8e3fa25b3ad@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-3-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> We already support 256 or more segments as long as the architecture
> supports SG chaining (all the ones that matter do), so removed the
> weird playing with limits from the job handler.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/bfa/bfad_bsg.c | 7 -------
>  1 file changed, 7 deletions(-)
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
