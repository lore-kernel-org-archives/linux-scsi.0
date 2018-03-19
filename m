From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 07:31:47 -0700
Message-ID: <20180319143147.GF2943022@devbig577.frc2.facebook.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180316173516.3048-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, Martin Steigerwald <martin@lichtvoll.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 16, 2018 at 10:35:16AM -0700, Bart Van Assche wrote:
> Since blk_queue_enter() uses rcu_read_lock_sched() scsi_device_quiesce()
> must use synchronize_sched().

Is there a reason to use sched-RCU here instead of the regular one?
If not, it'd be better to switch to regular RCU than the other way
around.

Thanks.

-- 
tejun
