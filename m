From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Mon, 20 Apr 2009 14:16:58 +0000
Message-ID: <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com>
	 <1239995314.6143.1.camel@zeppelin.austin.ibm.com>
	 <1240020307.5763.1.camel@mulgrave>
	 <1240235787.7458.13.camel@zeppelin.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41270 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbZDTORD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 10:17:03 -0400
In-Reply-To: <1240235787.7458.13.camel@zeppelin.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2009-04-20 at 10:56 -0300, Kleber S. Souza wrote:
> On Fri, 2009-04-17 at 22:05 -0400, James Bottomley wrote:
> > On Fri, 2009-04-17 at 16:08 -0300, Kleber S. Souza wrote:
> > > Hi,
> > >=20
> > > Any comments on this patch?=20
> > >=20
> > > It was acked by Brian King, do I need to do anything else to get =
it
> > > accepted?
> >=20
> > No ... looks OK to me:
> >=20
> > > Thanks,
> > > Kleber
> > >=20
> > > On Mon, 2009-03-23 at 17:12 -0300, Kleber Sacilotto de Souza wrot=
e:
> > > > Marking the ipr clean up function ipr_remove() as __devexit and=
 using
> > > > __devexit_p() macro in its address reference.
> > > >=20
> > > >=20
> > > > Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm=
=2Ecom>
> > > > Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
> >=20
> > Just explain this signoff?  signed-off-by is supposed to document t=
he
> > hands the patch has passed through ... it's not clear what Breno Le=
itao
> > has to do with the transmission of this patch.
> >=20
>=20
> Breno Leit=C3=A3o pointed out to me that this change needed to be mad=
e based
> on the kernel documentation <Documentation/PCI/pci.txt>. I wrote the
> patch, got the ack from Brian King and sent it to the list.

So that should be Reported-by: not Signed-off-by for Breno.

There's no actual ack from Brian King on this email.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
