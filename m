From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 06/25] mpt3sas: Define 'hba_mpi_version_belonged'
 IOC variable
Date: Wed, 11 Nov 2015 13:56:48 +0100
Message-ID: <56433B10.6080000@suse.de>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com> <1447243241-10912-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 11/11/2015 01:00 PM, Sreekanth Reddy wrote:
> From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
>=20
> 1. Use 'hba_mpi_version_belonged' IOC varable to uniquely
> identify each individual generation driver functionality at
> runtime.
>=20
> 2. Declared global variable 'driver_name' and used
> this variable while reserving PCI regions and while
> allocating the IRQ's.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_module.c |  1 +
>  drivers/scsi/mpt3sas/mpt3sas_base.c   |  8 +++----
>  drivers/scsi/mpt3sas/mpt3sas_base.h   |  3 +++
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 18 +++++++++++++---
>  drivers/scsi/mpt3sas/mpt3sas_module.c |  1 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 39 +++++++++++++++++++++++++=
+++++++++-
>  6 files changed, 62 insertions(+), 8 deletions(-)
>=20
I'd rather shorten that to 'hba_mpi_version'.

Other than that it's okay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
