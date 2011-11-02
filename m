From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/3] ata port runtime power management support
Date: Wed, 2 Nov 2011 08:17:11 -0700
Message-ID: <20111102151711.GB12543@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Nov 02, 2011 at 02:21:37PM +0800, Lin Ming wrote:
> These 3 patches add ata port runtime pm support, which is done through scsi layer.
> scsi host runtime pm mechanism is already there(scsi_pm.c).
> These patches add hooks for ata port.
> 
> Lin Ming (3):
>       scsi: fix potential dead lock for host runtime pm
>       scsi: add hooks for host runtime power management
>       ata: implement ata port runtime pm hooks

Hmmm.... Some questions.

* How much does this add on top of hardware timed auto spindown and
  dynamic link power management?

* Do the added benefits justify yet another runtime powersaving
  mechanism?

* Any way we can tie the other stuff with overall runtime PM?

Thanks.

-- 
tejun
