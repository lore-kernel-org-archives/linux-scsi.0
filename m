From: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Mon, 20 Apr 2009 10:56:17 -0300
Message-ID: <1240235787.7458.13.camel@zeppelin.austin.ibm.com>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
	 <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
	 <1240020307.5763.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:54537 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbZDTN5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 09:57:19 -0400
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by e24smtp03.br.ibm.com (8.13.1/8.13.1) with ESMTP id n3KDpvCg028277
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 10:51:57 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.18.232.46])
	by d24relay01.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KEuWqE3760372
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 11:56:32 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KDvDpU001099
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 10:57:14 -0300
In-Reply-To: <1240020307.5763.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-04-17 at 22:05 -0400, James Bottomley wrote:
> On Fri, 2009-04-17 at 16:08 -0300, Kleber S. Souza wrote:
> > Hi,
> >=20
> > Any comments on this patch?=20
> >=20
> > It was acked by Brian King, do I need to do anything else to get it
> > accepted?
>=20
> No ... looks OK to me:
>=20
> > Thanks,
> > Kleber
> >=20
> > On Mon, 2009-03-23 at 17:12 -0300, Kleber Sacilotto de Souza wrote:
> > > Marking the ipr clean up function ipr_remove() as __devexit and u=
sing
> > > __devexit_p() macro in its address reference.
> > >=20
> > >=20
> > > Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm.c=
om>
> > > Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
>=20
> Just explain this signoff?  signed-off-by is supposed to document the
> hands the patch has passed through ... it's not clear what Breno Leit=
ao
> has to do with the transmission of this patch.
>=20

Breno Leit=C3=A3o pointed out to me that this change needed to be made =
based
on the kernel documentation <Documentation/PCI/pci.txt>. I wrote the
patch, got the ack from Brian King and sent it to the list.


> James
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Kleber S. Souza
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
