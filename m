From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 09:06:29 +0200
Message-ID: <4292D275.8070409@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:22407 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261158AbVEXHGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 03:06:37 -0400
In-Reply-To: <4292CF5D.90809@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Jeff Garzik wrote:
[ .. ]
>=20
> Longer term, SATA PM through SCSI will have three facets:
>=20
> * Device PM.  This is best handled by the device class driver (sd/sr/=
st).
>=20
> * Bus PM.  This is best handled by the transport class driver (need t=
o
> write for SATA and SAS).
>=20
> * Host PM.  This is handled in the obvious manner, using existing PM
> driver hooks.  PCI D0/D3, etc.
>=20
> I can describe how this will look when libata is divorced from SCSI, =
if
> you would like, too...

Divorced from SCSI? Care to elaborate?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
