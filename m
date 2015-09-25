From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/4] scsi: remove old-style type names from sg.h
Date: Sat, 26 Sep 2015 01:50:10 +0200
Message-ID: <5605DDB2.6070406@suse.de>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/25/2015 11:27 AM, Paolo Bonzini wrote:
> These will not be exported by the new linux/sg.h header, and scsi/sg.=
h will
> not have any user API after linux/sg.h is created.  Since they have n=
o
> user in the kernel, they can be zapped.
>=20
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/scsi/sg.h | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/include/scsi/sg.h b/include/scsi/sg.h
> index 3afec7032448..370c78c37926 100644
> --- a/include/scsi/sg.h
> +++ b/include/scsi/sg.h
> @@ -207,12 +207,6 @@ typedef struct sg_req_info { /* used by SG_GET_R=
EQUEST_TABLE ioctl() */
> =20
>  #define SG_BIG_BUFF SG_DEF_RESERVED_SIZE    /* for backward compatib=
ility */
> =20
> -/* Alternate style type names, "..._t" variants preferred */
> -typedef struct sg_io_hdr Sg_io_hdr;
> -typedef struct sg_io_vec Sg_io_vec;
> -typedef struct sg_scsi_id Sg_scsi_id;
> -typedef struct sg_req_info Sg_req_info;
> -
> =20
>  /* vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=
vvvvv */
>  /*   The older SG interface based on the 'sg_header' structure follo=
ws.   */
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
