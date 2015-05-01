From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/9] scsi_dh: integrate into the core SCSI code
Date: Fri, 01 May 2015 09:13:18 +0200
Message-ID: <5543278E.8060205@suse.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbbEAHNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 03:13:20 -0400
In-Reply-To: <1430415151-30948-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 04/30/2015 07:32 PM, Christoph Hellwig wrote:
> Stop building scsi_dh as a separate module and integrate it fully int=
o the
> core SCSI code with explicit callouts at bus scan time.  For now the
> callouts are placed at the same point as the old bus notifiers were c=
alled,
> but in the future we will be able to look at ALUA INQUIRY data earlie=
r on.
>=20
> Note that this also means that the device handler modules need to be =
loaded
> by the time we scan the bus.  The next patches will add support for
> autoloading device handlers at bus scan time to make sure they are al=
ways
> loaded if they are enabled in the kernel config.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
