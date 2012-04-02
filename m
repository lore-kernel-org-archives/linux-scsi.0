From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
	of disks naming
Date: Mon, 2 Apr 2012 11:52:59 -0700
Message-ID: <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
	<20120330152606.GB28934@google.com>
	<20120330152808.GC28934@google.com>
	<4F78FE89.2070707@cn.fujitsu.com>
	<20120402072009.GF30360@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20120402072009.GF30360@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Apr 02, 2012 at 10:20:09AM +0300, Michael S. Tsirkin wrote:
> Pleae don't rename virtio disks, it is way too late for that:
> virtio block driver was merged around 2007, it is not new by
> any measure, and there are many systems out there using
> the current naming scheme.

There's no point in renaming device nodes of already deployed drivers.
It'll cause a lot of pain.

> > And how about the rssd in the patch 3 then?
> 
> Probably same. Renaming existing devices will break setups.
> I think the idea is to avoid using the
> legacy naming in new drivers *that will be added from now on*.

Yeap.

Thanks.

-- 
tejun
