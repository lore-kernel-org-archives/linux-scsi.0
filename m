From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 3/3] libata-scsi: add optimal transfer length to block
 limits VPD
Date: Wed, 13 Jul 2016 13:04:26 -0400
Message-ID: <20160713170426.GG4065@mtj.duckdns.org>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
 <5659242e8546753768944757fc86988f1986585c.1468384890.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5659242e8546753768944757fc86988f1986585c.1468384890.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 13, 2016 at 12:47:08PM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> As of commit 6b7e9cde4969 ("sd: Fix rw_max for devices that report
> an optimal xfer size"), the scsi disk driver (correctly) derive both
> of the queue limits "io_opt" and "max_sectors" from the optimal
> transfer length field.
> 
> In case we would like the two limits to be derived from a value
> other than BLK_DEF_MAX_SECTORS for ATA disks in the future, this
> patch has made it easy.

What's the actual impact of this patch at this point?

Thanks.

-- 
tejun
