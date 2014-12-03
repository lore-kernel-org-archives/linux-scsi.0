From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: remove scsi_get_tag_type
Date: Wed, 03 Dec 2014 14:33:27 +0100
Message-ID: <547F1127.8070005@suse.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLCNd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 08:33:28 -0500
In-Reply-To: <1416839781-26988-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/2014 03:36 PM, Christoph Hellwig wrote:
> Both remaining users are better of just checking sdev->simple_tags
> directly.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
