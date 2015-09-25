From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/4] scsi: cleanup scsi/scsi_ioctl.h
Date: Sat, 26 Sep 2015 01:51:38 +0200
Message-ID: <5605DE0A.9080607@suse.de>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/25/2015 11:27 AM, Paolo Bonzini wrote:
> SCSI_REMOVAL_* goes together with other SCSI command constants in
> include/scsi/scsi.h.  It is also used outside the implementation
> of the ioctls (and it is not part of the user API).
>=20
> scsi_fctargaddress/Scsi_FCTargAddress has had no in-tree use since
> commit ca61f10ab2b8 ("[SCSI] remove broken driver cpqfc", 2005-10-29)=
=2E
> Remove it, just in time for the the tenth anniversary of its demise.
>=20
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/scsi/scsi.h       | 6 ++++++
>  include/scsi/scsi_ioctl.h | 8 --------
>  2 files changed, 6 insertions(+), 8 deletions(-)
>=20
[ .. ]

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
