From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 09/11] block: Expose queue nr_zones in
	sysfs
Date: Fri, 12 Oct 2018 00:41:59 +0000
Message-ID: <BN3PR0401MB1640D90498CA644E582CCE46E7E20@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20181011070952.13248-1-damien.lemoal@wdc.com>
	<20181011070952.13248-10-damien.lemoal@wdc.com>
	<1539268936.20703.258.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 2018/10/11 23:42, Ewan D. Milne wrote:
> So in v2 you moved the #ifdef CONFIG_BLK_DEV_ZONED
> so that nr_zones is always present?  It was previously
> changed to keep the request_queue size smaller.
> 
> Would make more sense to make the nr_zones sysfs
> code here conditional on CONFIG_BLK_DEV_ZONED?
> 

Yes, I guess it would. #ifdef in c code is normally not welcome, so I was a
little heavy handed with this v2 change to avoid adding any to blk-sysfs.c :)

I will rework this and send a v3.

Thanks for the review.


-- 
Damien Le Moal
Western Digital Research
