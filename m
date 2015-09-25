From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/4] scsi: provide UAPI version of scsi/sg.h and
 scsi/scsi_ioctl.h
Date: Sat, 26 Sep 2015 01:55:47 +0200
Message-ID: <5605DF03.5080204@suse.de>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
 <1443173264-4105-5-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-5-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/25/2015 11:27 AM, Paolo Bonzini wrote:
> Provide a UAPI version of the header in the kernel, making it easier
> for interested projects to use an up-to-date version of the header.
>=20
> The new headers are placed under uapi/linux/ so as not to conflict
> with the glibc-provided headers in /usr/include/scsi.
>=20
> /dev/sgN default values are implementation aspects, and are moved to
> drivers/scsi/sg.c instead (together with e.g. SG_ALLOW_DIO_DEF).
> However, SG_SCATTER_SZ is used by Wine so it is kept in linux/sg.h
> SG_MAX_QUEUE could also be useful.
>=20
> struct scsi_ioctl_command and struct scsi_idlun used to be under
> "#ifdef __KERNEL__", but they are actually useful for userspace as
> well.  Add them to the new header.
>=20
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-scsi@vger.kernel.org
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
[ .. ]

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
