From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] Runtime PM support for AHCI host controller driver
Date: Fri, 19 Feb 2016 10:54:11 -0500
Message-ID: <20160219155411.GI13177@mtj.duckdns.org>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 18, 2016 at 10:54:10AM +0200, Mika Westerberg wrote:
> Linux already supports runtime PM of disks (drivers/scsi/sd.c) so that
> after certain amount of idle time the disk is suspended automatically. This
> series extends the support to AHCI host controllers. Whenever SATA ports
> are determined to be idle (all children are runtime suspended) the host
> controller is also suspended.
> 
> On recent Intel CPUs like Broxton this allows the CPU to go low power idle
> states like S0ix runtime (given that all necessary blocks are also in their
> correesponding low power states).
> 
> Patches [1-2/7] fix a lockup where disk is runtime suspended and the system
> is put to sleep. They are independent of the rest of the series.
> 
> Patch [3/7] makes it possible for SATA ports to be runtime suspended when
> there is not disk connected. For example on Lenovo Yoga 900 there are two
> SATA ports which only one of them has disk connected. This patch allows the
> host controller to runtime suspend whenever the disk is idle.

Applied to libata/for-4.6.

Thanks.

-- 
tejun
