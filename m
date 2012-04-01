From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/4] block: move sd_format_disk_name() into block core as
	disk_name_format()
Date: Sun, 1 Apr 2012 14:20:26 +0300
Message-ID: <20120401112025.GB23773@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2012 at 05:50:12PM +0800, Ren Mingxin wrote:
> 
> 
> This patch series renames "sd_format_disk_name()" to
> "disk_name_format()" and moves it into block core. So
> that who needs formatting disk name can use it, instead
> of duplicating these similar help functions.

I see there are some responses about naming and comments,
so that would need to be fixed.
Besides this, Jens, would you like to take the patchset
through your tree or prefer for me to merge it through virtio tree? 
Block tree seems more appropriate, right?
Also this is a bugfix technically since it fixes setups
with a ton of disks, so 3.4 material?

> Ren Mingxin (4):
>   block: add function disk_name_format() into block core
>   scsi: replace sd_format_disk_name() to disk_name_format()
>   block: replace rssd_disk_name_format() to disk_name_format()
>   virtio_blk: use disk_name_format() to support mass of disks naming
> 
>  block/genhd.c                     |   49 ++++++++++++++++++++++++++++++++++++++
>  drivers/block/mtip32xx/mtip32xx.c |   33 -------------------------
>  drivers/block/virtio_blk.c        |   13 ----------
>  drivers/scsi/sd.c                 |   48 -------------------------------------
>  include/linux/genhd.h             |    2 +
>  5 files changed, 54 insertions(+), 91 deletions(-)
> 
> Any comment will be appreciated.
> 
> Thanks,
> Ren
> 
