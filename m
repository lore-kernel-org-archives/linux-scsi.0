From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
Date: Tue, 10 Apr 2012 18:53:08 +0300
Message-ID: <20120410155308.GB20551@redhat.com>
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
	<4F84329A.60703@redhat.com> <20120410133406.GA18899@redhat.com>
	<20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, asamymuthupa@micron.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, James.Bottomley@HansenPartnership.com, Ren Mingxin <renmx@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10, 2012 at 08:49:43AM -0700, Tejun Heo wrote:
> Hello, guys.
> 
> On Tue, Apr 10, 2012 at 04:34:06PM +0300, Michael S. Tsirkin wrote:
> > > Why not use 'base' below?  neither unit nor base change.
> > 
> > Yes it's a bit strange, it was the same in Tejun's patch.
> > Tejun, any idea?
> 
> It was years ago, so I don't recall much.  I think I wanted to use a
> variable name which signifies its role - I worked out the rather
> convoluted base number logic on paper first and I probably wanted to
> keep the distinctions.  I don't think it really matters at this point
> tho.  Just make sure those functions are marked deprecated so that no
> one else copies them.
> 
> Thanks.

I guess I'll keep it same so it's easier to deduplicate
if someon wants to.

> -- 
> tejun
