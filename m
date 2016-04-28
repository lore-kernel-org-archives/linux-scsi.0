From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 08/10] aacraid: Remove code to needlessly complete fib
Date: Thu, 28 Apr 2016 09:47:34 +0200
Message-ID: <20160428074734.GL2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063226.28402.37546.stgit@pmcuser-System-Product-Name>
 <20160427092403.GE2820@c203.arch.suse.de>
 <4D8E82A446BF54499747901DBDEB737A1635319F@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbcD1Hri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 03:47:38 -0400
Content-Disposition: inline
In-Reply-To: <4D8E82A446BF54499747901DBDEB737A1635319F@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "JBottomley@odin.com" <JBottomley@odin.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Vishal Jose Mannanal <vishal.josemannanal@microsemi.com>

On Wed, Apr 27, 2016 at 04:34:35PM +0000, Raghava Aditya Renukunta wrot=
e:
>=20
> Hello Johannes,
>=20
> > > +                             dev_info(&dev->pdev->dev,
> > > +                             "Invalid callback_fib[%d] (*%p)(%p)=
\n",
> > > +                             index, fib->callback, fib->callback=
_data);
> >=20
> > I'm not sure INFO is the right logging level for this. WARN or ERRO=
R might be
> > more suited.
>=20
> I intended it be an acknowledgement that we ran into this issue. That=
 was why I used info,
> It should not impact the flow of the driver.

OK, I'm fine with the explanation

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
