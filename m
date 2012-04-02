From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
	of disks naming
Date: Mon, 2 Apr 2012 12:00:45 -0700
Message-ID: <20120402190045.GC16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
	<20120330152606.GB28934@google.com>
	<20120330152808.GC28934@google.com>
	<4F78FE89.2070707@cn.fujitsu.com>
	<20120402072009.GF30360@redhat.com>
	<20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
	<1333392978.2971.25.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1333392978.2971.25.camel@dabdike>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On Mon, Apr 02, 2012 at 11:56:18AM -0700, James Bottomley wrote:
> So if we're agreed no other devices going forwards should ever use this
> interface, is there any point unifying the interface?  No matter how
> many caveats you hedge it round with, putting the API in a central place
> will be a bit like a honey trap for careless bears.   It might be safer
> just to leave it buried in the three current drivers.

Yeah, that was my hope but I think it would be easier to enforce to
have a common function which is clearly marked legacy so that new
driver writers can go look for the naming code in the existing ones,
find out they're all using the same function which is marked legacy
and explains what to do for newer drivers.

Thanks.

-- 
tejun
