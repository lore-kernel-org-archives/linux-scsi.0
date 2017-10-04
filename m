From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/9] bsg-lib: remove bsg_job.req
Date: Wed, 4 Oct 2017 08:22:54 +0200
Message-ID: <d40e2f7d-7d11-df80-9890-e2197f5ca672@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-8-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> Users of the bsg-lib interface should only use the bsg_job data structure
> and not know about implementation details of it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg-lib.c         | 14 ++++++--------
>  include/linux/bsg-lib.h |  1 -
>  2 files changed, 6 insertions(+), 9 deletions(-)
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
