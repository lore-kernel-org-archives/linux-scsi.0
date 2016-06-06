From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 41/45] block, drivers, fs: shrink bi_rw from long to int
Date: Mon, 6 Jun 2016 08:51:40 +0200
Message-ID: <57551D7C.8000004@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-42-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465155145-10812-42-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>=20
> We don't need bi_rw to be so large on 64 bit archs, so
> reduce it to unsigned int.
>=20
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  block/blk-core.c           | 2 +-
>  drivers/md/dm-flakey.c     | 2 +-
>  drivers/md/raid5.c         | 6 +++---
>  fs/btrfs/check-integrity.c | 4 ++--
>  fs/btrfs/inode.c           | 2 +-
>  include/linux/blk_types.h  | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
