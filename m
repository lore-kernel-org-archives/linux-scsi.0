From: Jens Axboe <axboe@kernel.dk>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Tue, 9 Feb 2016 10:14:04 -0700
Message-ID: <56BA1E5C.7040108@kernel.dk>
References: <1454783624.2809.6.camel@HansenPartnership.com>
 <20160207092241.GA15331@lst.de>
 <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk>
 <20160209125011.GC25353@lst.de>
 <CB24E0BA-5A48-4D57-9B81-A81F6598F32F@kernel.dk>
 <20160209171229.GA30378@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160209171229.GA30378@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/09/2016 10:12 AM, Christoph Hellwig wrote:
> Does this looks reasonable?
>
> ---
>  From 7843fae979df3fc14007735f54cc6bb2f6f66dc5 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 9 Feb 2016 18:11:32 +0100
> Subject: nvme: fix Kconfig description for BLK_DEV_NVME_SCSI
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/nvme/host/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index 59307f8..2e24156 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -17,8 +17,8 @@ config BLK_DEV_NVME_SCSI
>   	  and block devices nodes, as well a a translation for a small
>   	  number of selected SCSI commands to NVMe commands to the NVMe
>   	  driver.  If you don't know what this means you probably want
> -	  to say N here, and if you know what it means you probably
> -	  want to say N as well.
> +	  to say N here, unless you run a distro that abuses this for
> +	  stable device names like some OpenSuSE and SLES versions.

Yep, that looks a lot more reasonable to me. Might be wort including 
that it impacts the mount-by-id on those distros.

-- 
Jens Axboe
