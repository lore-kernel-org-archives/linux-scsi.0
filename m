From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/5] Replace MAX_COMMAND_SIZE with BLK_MAX_CDB
Date: Fri, 08 May 2015 14:37:44 +0200
Message-ID: <554CAE18.7080000@suse.de>
References: <554C6E79.7020501@sandisk.com> <554C6EFF.5000400@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <554C6EFF.5000400@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/08/2015 10:08 AM, Bart Van Assche wrote:
> Since the two constants MAX_COMMAND_SIZE and BLK_MAX_CDB have
> the same meaning, replace MAX_COMMAND_SIZE with BLK_MAX_CDB.
>=20
> This patch has been generated as follows:
> - Removed the MAX_COMMAND_SIZE definitions manually from
>   <scsi/scsi_cmnd.h> and also from
>   drivers/usb/gadget/function/storage_common.h.
> - Ran the following command over the Linux source tree:
>   sed -i.orig 's/\([^a-zA-Z_]\)MAX_COMMAND_SIZE/\1BLK_MAX_CDB/g' $(gi=
t grep -lw MAX_COMMAND_SIZE)
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
