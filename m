From: Oleksandr Natalenko <oleksandr-L/hGvWKi9zur34vxu0UX7A@public.gmane.org>
Subject: Re: Slow boot in QEMU with virtio-scsi disks
Date: Sat, 11 Aug 2018 19:39:56 +0200
Message-ID: <98344e68266e447826f133ad14d0c83d@natalenko.name>
References: <f40092b20856d07bd7f870abf5ea939e@natalenko.name>
	<CACVXFVO1pN=CZvNY8Q4wBrAoA=3w8Ew38aGqpOSHJ1uYAM-sxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <qemu-discuss-bounces+gceqd-qemu-discuss=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
In-Reply-To: <CACVXFVO1pN=CZvNY8Q4wBrAoA=3w8Ew38aGqpOSHJ1uYAM-sxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-discuss>,
	<mailto:qemu-discuss-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-discuss/>
List-Post: <mailto:qemu-discuss-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:qemu-discuss-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-discuss>,
	<mailto:qemu-discuss-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Errors-To: qemu-discuss-bounces+gceqd-qemu-discuss=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
Sender: "Qemu-discuss"
	<qemu-discuss-bounces+gceqd-qemu-discuss=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
To: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kurz <groug-Bxea+6Xhats@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, qemu-discuss-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi.

On 11.08.2018 14:23, Ming Lei wrote:
> Please test for-4.19/block:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=for-4.19/block
> 
> This slow boot issue should have been fixed by the following commits:
> 
> 1311326cf475 blk-mq: avoid to synchronize rcu inside 
> blk_cleanup_queue()
> 97889f9ac24f blk-mq: remove synchronize_rcu() from 
> blk_mq_del_queue_tag_set()
> 5815839b3ca1 blk-mq: introduce new lock for protecting 
> hctx->dispatch_wait
> 2278d69f030f blk-mq: don't pass **hctx to blk_mq_mark_tag_wait()
> 8ab6bb9ee8d0 blk-mq: cleanup blk_mq_get_driver_tag()

Indeed, I can confirm that these commits fix the issue.

Thanks a lot.

-- 
   Oleksandr Natalenko (post-factum)
