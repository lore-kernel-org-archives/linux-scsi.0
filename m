From: Adam Manzanares <adam.manzanares@wdc.com>
Subject: Re: [PATCH v5 4/4] ata: ATA Command Priority Disabled By Default
Date: Thu, 13 Oct 2016 16:37:43 -0700
Message-ID: <20161013233742.GA5854@hgst.com>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
 <1476399631-5799-5-git-send-email-adam.manzanares@hgst.com>
 <20161013232230.GB32534@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161013232230.GB32534@mtj.duckdns.org>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Adam Manzanares <adam.manzanares@hgst.com>, axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Tejun,

The 10/13/2016 19:22, Tejun Heo wrote:
> Hello, Adam.
> 
> Sorry about late reply.  Was on vacation.

NP I was on vacation at the end of the week last week.

> 
> On Thu, Oct 13, 2016 at 04:00:31PM -0700, Adam Manzanares wrote:
> > Add a sysfs entry to turn on priority information being passed
> > to a ATA device. By default this feature is turned off.
> > 
> > This patch depends on ata: Enabling ATA Command Priorities
> 
> Looks generally good but can we please use a device attribute name
> which is more specific - ie. enable_ncq_prio?

Will do, I'll also double check the naming scheme of functions and variables 
also. The functions that check if the device has the ncq prio capability might
be too similar to the function that checks if the device attribute is 
enabled.

> 
> Thanks.
> 
> -- 
> tejun

Take care,
Adam
