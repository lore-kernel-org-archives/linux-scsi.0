From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 3/4] ata: Enabling ATA Command Priorities
Date: Thu, 13 Oct 2016 19:23:13 -0400
Message-ID: <20161013232313.GC32534@mtj.duckdns.org>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
 <1476399631-5799-4-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476399631-5799-4-git-send-email-adam.manzanares@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Oct 13, 2016 at 04:00:30PM -0700, Adam Manzanares wrote:
> This patch checks to see if an ATA device supports NCQ command priorities.
> If so and the user has specified an iocontext that indicates
> IO_PRIO_CLASS_RT then we build a tf with a high priority command.
> 
> This is done to improve the tail latency of commands that are high
> priority by passing priority to the device.
> 
> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>

Looks good to me.  Once the block changes are applied, I'll pull it
into libata tree and apply the ata part on top.

Thanks.

-- 
tejun
