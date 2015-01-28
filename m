From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] ata: pata_platform: fix owner module reference
 mismatch for scsi host
Date: Wed, 28 Jan 2015 18:53:47 -0500
Message-ID: <20150128235347.GB12369@htj.dyndns.org>
References: <1422487830-5366-1-git-send-email-akinobu.mita@gmail.com>
 <1422487830-5366-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422487830-5366-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-ide@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 29, 2015 at 08:30:30AM +0900, Akinobu Mita wrote:
> The owner module reference of the pata_of_platform's scsi_host is
> initialized to pata_platform's one, because pata_of_platform driver
> use a scsi_host_template defined in pata_platform.  So this drivers
> can be unloaded even if the scsi device is being accessed.
> 
> This fixes it by propagating the scsi_host_template to pata_of_platform
> driver.  The scsi_host_template is passed through a new
> argument of __pata_platform_probe().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org

Applied 1-2 to libata/for-3.20.

Thanks.

-- 
tejun
