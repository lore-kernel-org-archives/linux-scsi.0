From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 06/11] block: Introduce BLKGETZONESZ ioctl
Date: Wed, 10 Oct 2018 09:53:26 -0700
Message-ID: <1539190406.195557.4.camel@acm.org>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
	<20181010015239.24930-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5545328523444814217=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010015239.24930-7-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K .
	Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

--===============5545328523444814217==
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit

On Wed, 2018-10-10 at 10:52 +-0900, Damien Le Moal wrote:
+AD4  +ACM-define BLKREPORTZONE	+AF8-IOWR(0x12, 130, struct blk+AF8-zone+AF8-report)
+AD4  +ACM-define BLKRESETZONE	+AF8-IOW(0x12, 131, struct blk+AF8-zone+AF8-range)
+AD4 +-+ACM-define BLKGETZONESZ	+AF8-IOW(0x12, 132, unsigned int)

>From Documentation/ioctl/botching-up-ioctls.txt, a collection of lessons learned
the hard way about ioctls:

 +ACo Only use fixed sized integers. To avoid conflicts with typedefs in userspace
   the kernel has special types like +AF8AXw-u32, +AF8AXw-s64. Use them.

Please follow that advice.

Thanks,

Bart.


--===============5545328523444814217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5545328523444814217==--
