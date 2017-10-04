From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] bsg-lib: introduce a timeout field in struct bsg_job
Date: Wed, 4 Oct 2017 08:21:57 +0200
Message-ID: <4d7df23e-2da2-635e-e7bb-4802cef79fe9@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-7-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> The zfcp driver wants to know the timeout for a bsg job, so add a field
> to struct bsg_job for it in preparation of not exposing the request
> to the bsg-lib users.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c             | 1 +
>  drivers/s390/scsi/zfcp_fc.c | 4 ++--
>  include/linux/bsg-lib.h     | 2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
