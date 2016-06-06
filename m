From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 42/45] block, fs, drivers: remove REQ_OP compat defs and
 related code
Date: Mon, 6 Jun 2016 08:53:04 +0200
Message-ID: <57551DD0.9090703@suse.de>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-43-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465155145-10812-43-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 06/05/2016 09:32 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>=20
> This patch drops the compat definition of req_op where it matches
> the rq_flag_bits definitions, and drops the related old and compat
> code that allowed users to set either the op or flags for the operati=
on.
>=20
> We also then store the operation in the bi_rw/cmd_flags field similar
> to how we used to store the bio ioprio where it sat in the upper bits
> of the field.
>=20
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/scsi/sd.c           |  2 +-
>  include/linux/bio.h         |  3 ---
>  include/linux/blk_types.h   | 52 +++++++++++++++++------------------=
----------
>  include/linux/blkdev.h      | 14 ++++++++----
>  include/linux/fs.h          | 37 +++++++++++++-------------------
>  include/trace/events/f2fs.h |  1 -
>  6 files changed, 46 insertions(+), 63 deletions(-)
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
