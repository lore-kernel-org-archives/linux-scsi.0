From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: rescan_partitions() in SCSI disk driver
Date: Thu, 13 Jul 2006 13:06:22 +0200
Message-ID: <20060713110622.GF31644@harddisk-recovery.com>
References: <004001c6a62c$5290c8f0$73a5580a@swcenter.sec.samsung.co.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:3961 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S1751521AbWGMLGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 07:06:24 -0400
Content-Disposition: inline
In-Reply-To: <004001c6a62c$5290c8f0$73a5580a@swcenter.sec.samsung.co.kr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kokachev Oleksiy <o.kokachev@samsung.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 13, 2006 at 12:27:51PM +0900, Kokachev Oleksiy wrote:
> I'm trying to make some modifications to SCSI driver to correctly sync
> /proc/partitions when new disk is inserted.
> To revalidate disk I used sd_revalidate_disk(), but this function revalidate
> only disk info, but do not rescan partition table. How can I tell the driver
> to correctly rescan part/ table? I've tried to use rescan_partitions()
> function like below, but failed:
> 	struct scsi_disk *sdkp;
>       bdev = bdget_disk(sdkp->disk, 0);
> 	rescan_partitions(sdkp->disk, bdev);
> But in this case bdev->bd_disk is NULL. Why? What did I do not correct?

Can be done from userland: blockdev --rereadpt /dev/whatever .


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
