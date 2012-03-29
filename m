From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: add helper function to support mass of disks
	naming
Date: Thu, 29 Mar 2012 15:10:01 +1030
Message-ID: <87ehscyq8u.fsf@rustcorp.com.au>
References: <4F72B5B3.6020602@cn.fujitsu.com>
	<20120328105819.GD6194@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120328105819.GD6194@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, jens.axboe@oracle.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Mar 2012 12:58:21 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Mar 28, 2012 at 02:54:43PM +0800, Ren Mingxin wrote:
> >  Hi,
> > 
> > The current virtblk's naming algorithm just supports 26^3
> > disks. If there are mass of virtblks(exceeding 26^3), there
> > will be disks with the same name.
> > 
> > According to "sd_format_disk_name()", I add function
> > "virtblk_name_format()" for virtblk to support mass of
> > disks.
> > 
> > Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> 
> Nod. This is basically what 3e1a7ff8a0a7b948f2684930166954f9e8e776fe
> did. Except, maybe we should move this function into block core
> instead of duplicating it? Where would be a good place to put it?
> Jens, care to comment?

Indeed.

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
