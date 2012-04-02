From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Date: Mon, 02 Apr 2012 11:56:18 -0700
Message-ID: <1333392978.2971.25.camel@dabdike>
References: <4F7581D4.4040301@cn.fujitsu.com>
	 <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com>
	 <20120330152808.GC28934@google.com> <4F78FE89.2070707@cn.fujitsu.com>
	 <20120402072009.GF30360@redhat.com>
	 <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-04-02 at 11:52 -0700, Tejun Heo wrote:
> > Probably same. Renaming existing devices will break setups.
> > I think the idea is to avoid using the
> > legacy naming in new drivers *that will be added from now on*.
> 
> Yeap.

So if we're agreed no other devices going forwards should ever use this
interface, is there any point unifying the interface?  No matter how
many caveats you hedge it round with, putting the API in a central place
will be a bit like a honey trap for careless bears.   It might be safer
just to leave it buried in the three current drivers.

James
