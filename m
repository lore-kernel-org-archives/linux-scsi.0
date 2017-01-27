From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 11/18] scsi: remove gfp_flags member in
 scsi_host_cmd_pool
Date: Fri, 27 Jan 2017 17:38:47 +0000
Message-ID: <1485538708.4267.12.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-12-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485365126-23210-12-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <98D6B26F49E55946B382644736870932@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> When using the slab allocator we already decide at cache creation time if
> an allocation comes from a GFP_DMA pool using the SLAB_CACHE_DMA flag,
> and there is no point passing the kmalloc-family only GFP_DMA flag to
> kmem_cache_alloc.  Drop all the infrastructure for doing so.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
