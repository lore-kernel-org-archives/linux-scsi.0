From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH 1/4] block: add zone open, close and finish support
Date: Sat, 22 Jun 2019 15:04:44 +0900
Message-ID: <20190622060444.GA6975@minwooim-desktop>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-2-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190621130711.21986-2-mb@lightnvm.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias =?utf-8?B?QmrDuHJsaW5n?= <mb@lightnvm.io>
Cc: axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Matias =?utf-8?B?QmrDuHJsaW5n?= <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 19-06-21 15:07:08, Matias Bjørling wrote:
> @@ -226,6 +228,9 @@ int blkdev_reset_zones(struct block_device *bdev,
>  	if (!blk_queue_is_zoned(q))
>  		return -EOPNOTSUPP;
>  
> +	if (!op_is_zone_mgmt_op(op))
> +		return -EOPNOTSUPP;
> +

nitpick: -EINVAL looks better to return as Damien pointed out.

Otherwise it looks good to me:

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
