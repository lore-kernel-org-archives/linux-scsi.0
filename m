From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1 4/4] libiscsi: Use scsi helper to set information descriptor
Date: Wed, 15 Jul 2015 10:07:04 +0200
Message-ID: <55A614A8.9020807@suse.de>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com> <1436946939-19415-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436946939-19415-5-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 07/15/2015 09:55 AM, Sagi Grimberg wrote:
> In case encountered a PI error, use scsi_set_sense_information
> instead of open coding information descriptor format.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/scsi/libiscsi.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
