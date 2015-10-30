From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 00/15] Big fixes, retries, handle a race condition
Date: Fri, 30 Oct 2015 13:20:09 +0100
Message-ID: <56336079.60509@suse.de>
References: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>, robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

On 10/28/2015 02:13 PM, Yaniv Gardi wrote:
> Important:
> This serie of 15 small patches should be pushed after the series of 8=
 patches
> "Fix error message and present UFS variant probe"
>=20
> V6:
> update Reviewed-by from various reviewers
>=20
> V5:
> removed un-necessary wmb()
>=20
> V4:
> fixing a few comments from reviewers
>=20
> V3:
> removed specific calls to wmb() since they are redundant.
>=20
> V2:
> a few minor changes
>=20
> V1:
> This serie of 15 small patches should be pushed after the series of 8=
 patches
> I have uploaded to the upstream a week ago:
> "Fix error message and present UFS variant probe"
>=20
> Yaniv Gardi (15):
>   scsi: ufs: clear UTRD, UPIU req and rsp before new transfers
>   scsi: ufs: clear fields UTRD, UPIU req and rsp before new transfers
>   scsi: ufs: verify command tag validity
>   scsi: ufs: clear outstanding_request bit in case query timeout
>   scsi: ufs: increase fDeviceInit query response timeout
>   scsi: ufs: avoid exception event handler racing with PM callbacks
>   scsi: ufs: set REQUEST_SENSE command size to 18 bytes
>   scsi: ufs: add retries to dme_peer get and set attribute
>   scsi: ufs: add retries for hibern8 enter
>   scsi: ufs: fix error recovery after the hibern8 exit failure
>   scsi: ufs: retry failed query flag requests
>   scsi: ufs: reduce the interrupts for power mode change requests
>   scsi: ufs: add missing memory barriers
>   scsi: ufs: commit descriptors before setting the doorbell
>   scsi: ufs: add wrapper for retrying sending query attribute
>=20
>  drivers/scsi/ufs/ufshcd.c | 408 ++++++++++++++++++++++++++++++++++++=
----------
>  drivers/scsi/ufs/ufshcd.h |   4 +
>  2 files changed, 327 insertions(+), 85 deletions(-)
>=20
Except for patch 07/15:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
