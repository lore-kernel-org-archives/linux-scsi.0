From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 19 Jun 2014 23:08:22 -0400
Message-ID: <yq1ionwjn15.fsf@sermon.lab.mkp.net>
References: <53A28B21.7070500@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53A28B21.7070500@profihost.ag> (Stefan Priebe's message of "Thu,
	19 Jun 2014 09:02:57 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>, Lars Ellenberg <lars.ellenberg@linbit.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Stefan" == Stefan Priebe <- Profihost AG <s.priebe@profihost.ag>> writes:

Stefan> Hi, while using vanilla 3.10.44 with drbd on top of a md raid1.

Stefan> I'm pretty often hitting the followin kernel bug.

Stefan> [<ffffffff8128105c>] blk_add_request_payload+0xc/0x90

That's really messed up. This means we received a request with no bio.

Does this happen with later kernels?

-- 
Martin K. Petersen	Oracle Linux Engineering
