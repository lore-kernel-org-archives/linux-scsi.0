From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 4/5] target: Use scsi helpers to build the sense data
 correctly
Date: Wed, 08 Jul 2015 17:07:22 +0200
Message-ID: <559D3CAA.2090900@suse.de>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com> <1436367534-15995-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbbGHPHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 11:07:24 -0400
In-Reply-To: <1436367534-15995-5-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 07/08/2015 04:58 PM, Sagi Grimberg wrote:
> Instead of open coding the sense buffer construction, use
> scsi scsi_build_sense_buffer() and scsi_set_sense_information()
> helpers which moved to scsi_common.
>=20
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/target/target_core_spc.c       | 31 +++++-------------------=
-------
>  drivers/target/target_core_transport.c | 21 ++++-----------------
>  2 files changed, 9 insertions(+), 43 deletions(-)
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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
