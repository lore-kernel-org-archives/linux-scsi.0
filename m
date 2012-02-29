From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] block: fix __blkdev_get and add_disk race condition
Date: Wed, 29 Feb 2012 15:57:11 +0100
Message-ID: <20120229145710.GB20516@redhat.com>
References: <20120222165948.GA12961@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120222165948.GA12961@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 22, 2012 at 05:59:49PM +0100, Stanislaw Gruszka wrote:
> I use the script to verify patch fixing oops in sd_revalidate_disk
> http://marc.info/?l=linux-scsi&m=132935572512352&w=2
> Without Jun'ichi Nomura patch titled "Fix NULL pointer dereference in
> sd_revalidate_disk" or this one, script easily crash kernel within
> a few seconds.

Jens could you pick up both patches for 3.3 ? Both are actually a -stable
fixes, despite they are not marked so, perhaps we should repost patches
with that mark?

Thanks
Stanislaw
