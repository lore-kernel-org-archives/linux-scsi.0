From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 09:29:21 -0700
Message-ID: <20180319162921.GS2943022@devbig577.frc2.facebook.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
 <20180319143147.GF2943022@devbig577.frc2.facebook.com>
 <1521472566.2776.6.camel@wdc.com>
 <20180319152144.GM2943022@devbig577.frc2.facebook.com>
 <1521476333.2776.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521476333.2776.9.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Mar 19, 2018 at 04:18:54PM +0000, Bart Van Assche wrote:
> The algorithm explained above does not depend on sched-rcu. But because
> percpu_ref_tryget_live() uses sched-rcu and because we need to add an RCU lock
> around that call we are forced to use sched-rcu. I hope this makes it clear.

This could be me being slow but can you explain how what
percpu_ref_tryget_live() uses internally affects whether we can use
regular RCU around it?

Thanks.

-- 
tejun
