From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/9] block: pass full fmode_t to blk_verify_command
Date: Wed, 4 Oct 2017 08:23:33 +0200
Message-ID: <ab9b6c15-84cd-f808-9e38-be3b16b9d350@suse.de>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171003104845.10417-9-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 10/03/2017 12:48 PM, Christoph Hellwig wrote:
> Use the obvious calling convention.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg.c            | 18 ++++++++----------
>  block/scsi_ioctl.c     |  8 ++++----
>  drivers/scsi/sg.c      |  2 +-
>  include/linux/blkdev.h |  2 +-
>  4 files changed, 14 insertions(+), 16 deletions(-)
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
