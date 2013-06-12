From: Jens Axboe <axboe@kernel.dk>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1196 scsi_setup_fs_cmnd
 during RAID5 startup.
Date: Wed, 12 Jun 2013 14:18:55 -0600
Message-ID: <20130612201855.GJ2600@kernel.dk>
References: <20130612194346.GD15200@redhat.com>
 <20130612201047.GF15200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130612201047.GF15200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 12 2013, Dave Jones wrote:
> On Wed, Jun 12, 2013 at 03:43:46PM -0400, Dave Jones wrote:
>  > 3.10 seems to have a problem with dirty RAID5 sets.
>  > 
>  > I've got a machine that panics on boot during RAID5 activation.
>  > After switching the BUG_ON to a WARN_ON, I was able to get this over serial console..
>  > 
>  > md/raid:md0: not clean -- starting background reconstruction
>  > md/raid:md0: device sdd1 operational as raid disk 2
>  > md/raid:md0: device sdc1 operational as raid disk 1
>  > md/raid:md0: device sdb1 operational as raid disk 0
>  > md/raid:md0: allocated 3300kB
>  > md/raid:md0: raid level 5 active with 3 out of 3 devices, algorithm 2
>  > md0: detected capacity change from 0 to 499847790592
>  > md: resync of RAID array md0
>  > md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>  > md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
>  > md: using 128k window, over a total of 244066304k.
>  > md: resuming resync of md0 from checkpoint.
>  > WARNING: at drivers/scsi/scsi_lib.c:1196 scsi_setup_fs_cmnd+0xa3/0xb0()
> 
> https://lkml.org/lkml/2013/5/19/75
> 
> I think my favorite part of this month old thread is..
> 
> "in that case we could have waited for a long time"
> 
> Jens?

Sorry, travel ended up getting in the way. Will ship it out today.

-- 
Jens Axboe
