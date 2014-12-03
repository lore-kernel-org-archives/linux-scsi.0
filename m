From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] fc: FCP_PTA_SIMPLE is 0
Date: Wed, 03 Dec 2014 15:09:42 +0100
Message-ID: <547F19A6.3010000@suse.de>
References: <1416927010-6036-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaLCOJo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 09:09:44 -0500
In-Reply-To: <1416927010-6036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/25/2014 03:50 PM, Christoph Hellwig wrote:
> Not need to have an if/else to either assign FCP_PTA_SIMPLE or 0
> to a variable.
>=20
> Btw, it seems we really should factor generating a fcp cmnd from
> a scsi_cmnd into a common helper.
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
