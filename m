From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Mon, 09 Nov 2015 15:04:38 +0100
Message-ID: <5640A7F6.6050201@suse.de>
References: <1447077232-5335-1-git-send-email-lvivier@redhat.com> <1447077232-5335-4-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447077232-5335-4-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>, martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 02:53 PM, Laurent Vivier wrote:
> QEMU allows until 32 LUNs.
>=20
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 9 ++++++++-
>  drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
>=20
Nothing to do with QEMU; this is a driver limitation.
Please fixup the description.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
