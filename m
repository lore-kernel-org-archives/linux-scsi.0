From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 3/4] scsi: move all obsolete ioctls to scsi_ioctl.h
Date: Sat, 26 Sep 2015 01:52:26 +0200
Message-ID: <5605DE3A.3040206@suse.de>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-4-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/25/2015 11:27 AM, Paolo Bonzini wrote:
> Some are in scsi.h.  Keep them together in preparation for exposing t=
hem
> in UAPI headers.
>=20
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/scsi/scsi.h       | 20 --------------------
>  include/scsi/scsi_ioctl.h | 20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 20 deletions(-)
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
