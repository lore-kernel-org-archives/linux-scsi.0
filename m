From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_debug 1.64 , remove detect(), "hotplug" hosts
Date: Sat, 9 Nov 2002 17:27:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021110012748.GA1301@beaverton.ibm.com>
References: <3DCCE2E6.6050800@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DCCE2E6.6050800@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> Notes:
>   - Christoph and Mike A. are pulling me in 2 different
>     directions. In this case Christoph got to me first
>     so I have moved along that direction. Mike's
>     "/sysfs/bus/scsi_dbg_fake" has me perplexed ...

I was not trying to pull in another direction, but my patches may have
had to many steps in one chunk that may have made it look that way. 

I have split the functionality of my previous patch for scsi_debug into
smaller chunks. I believe there are advantages to scsi mid code and the
device model code in making scsi_debug look more like a real adapter.

I need to do more testing hopefully I can send you something Sunday if
you are interested.

>   - rmmod and subsequent modprobe's on scsi_debug
>     sometimes blow up.
>     Hopefully Patrick's fix (not in bk3?) addresses that.

I would use the changes that Patrick sent out as we had problems
with insmod / rmmod without these. I previously sent these to Mochel,
but he was in the process of moving and they probably will not show up
in a bk ( or fixes like these) until he can respond.

It seemed when I was re-working my patches that num_hosts_present is
used during scsi_debug_exit to cleanup, but is not incremented during
sdebug_add_host_write. There seems to a mixed use of scsi_debug_add_host
and num_hosts_present.

-andmike
--
Michael Anderson
andmike@us.ibm.com

