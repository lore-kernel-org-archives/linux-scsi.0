From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mpt2sas: use mpi headers from mpt3sas
Date: Tue, 13 Jan 2015 16:41:03 +0100
Message-ID: <54B53C8F.802@suse.de>
References: <1421162971-16725-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbbAMPlG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2015 10:41:06 -0500
In-Reply-To: <1421162971-16725-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 01/13/2015 04:29 PM, Christoph Hellwig wrote:
> Use a single set of the hardware description headers instead of
> having them in the source tree twice.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A round of applause.

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
