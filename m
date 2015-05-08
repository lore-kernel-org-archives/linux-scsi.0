From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 4/5] target: Correct a comment
Date: Fri, 08 May 2015 14:38:00 +0200
Message-ID: <554CAE28.3040107@suse.de>
References: <554C6E79.7020501@sandisk.com> <554C6F17.30501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <554C6F17.30501@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/08/2015 10:08 AM, Bart Van Assche wrote:
> Correct the comment above the definition of TCM_MAX_COMMAND_SIZE.
> A quote from Christoph:
>=20
>     There aren't any legacy issues, we just decided to handle >
>     16 byte CDBs in the slow path.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  include/target/target_core_base.h | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/target/target_core_base.h b/include/target/targe=
t_core_base.h
> index 480e9f8..0203774 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -17,16 +17,8 @@
>  /* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
>  #define TRANSPORT_MAX_LUNS_PER_TPG		256
>  /*
> - * By default we use 32-byte CDBs in TCM Core and subsystem plugin c=
ode.
> - *
> - * Note that both include/scsi/scsi_cmnd.h:MAX_COMMAND_SIZE and
> - * include/linux/blkdev.h:BLOCK_MAX_CDB as of v2.6.36-rc4 still use
> - * 16-byte CDBs by default and require an extra allocation for
> - * 32-byte CDBs to because of legacy issues.
> - *
> - * Within TCM Core there are no such legacy limitiations, so we go a=
head
> - * use 32-byte CDBs by default and use include/scsi/scsi.h:scsi_comm=
and_size()
> - * within all TCM Core and subsystem plugin code.
> + * Maximum size of a CDB that can be stored in se_cmd without alloca=
ting
> + * memory dynamically for the CDB.
>   */
>  #define TCM_MAX_COMMAND_SIZE			32
>  /*
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
