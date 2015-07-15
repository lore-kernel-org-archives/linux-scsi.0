From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 3/4] target: Return descriptor format sense data in
 case the LU spans 64bit sectors
Date: Wed, 15 Jul 2015 10:06:05 +0200
Message-ID: <55A6146D.50602@suse.de>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com> <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbbGOIGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 04:06:09 -0400
In-Reply-To: <1436946939-19415-4-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 07/15/2015 09:55 AM, Sagi Grimberg wrote:
> In case a LU spans 64bit sectors, fixed size sense data information
> field is only 32 bits which means the sector information will be trun=
cated.
>=20
> Thus, if the LU spans 64bit sectors, use descriptor format sense data=
 to
> correctly report sector information.
>=20
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/target/target_core_hba.c       |  5 +++++
>  drivers/target/target_core_spc.c       | 12 +++++++++---
>  drivers/target/target_core_transport.c |  3 ++-
>  include/target/target_core_backend.h   |  2 ++
>  4 files changed, 18 insertions(+), 4 deletions(-)
>=20
We should eventually move to have the D_SENSE parameter changeable,
But in the meantime:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
