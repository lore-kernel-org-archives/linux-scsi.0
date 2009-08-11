From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: more arrays for scsi_dh_rdac.c
Date: Tue, 11 Aug 2009 11:32:39 -0700
Message-ID: <1250015559.19104.8.camel@chandra-ubuntu>
References: <981814294.1338791249997612929.JavaMail.root@mail6.gatech.edu>
	 <1416234192.1340021249997884445.JavaMail.root@mail6.gatech.edu>
	 <E463DF2B2E584B4A82673F53D62C2EF474AEAF70@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39876 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZHKS2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 14:28:37 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7BIJij5032168
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 12:19:44 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7BISX46242448
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 12:28:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7BISXQN005789
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 12:28:33 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474AEAF70@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "rick.brown@oit.gatech.edu" <rick.brown@oit.gatech.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks for verifying it Babu.

Is there any more devices you know that we need to add to this list ?

regards,

chandra
On Tue, 2009-08-11 at 10:30 -0600, Moger, Babu wrote:
> Rick,=20
> Looks like Chandra is going to add these strings in scsi_dh_rdac.c.
>=20
> Can you please confirm the second string? Shouldn't it be read as {"S=
UN", "CSM100_R_FC"}?
>   =20
>=20
> Thanks
> Babu Moger=20
>=20
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of rick.brown@oit.gatech.edu
> > Sent: Tuesday, August 11, 2009 8:38 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: more arrays for scsi_dh_rdac.c
> >=20
> > Please consider adding the following two devices to the devlist in
> > scsi_dc_rdac.c
> >=20
> > {"STK", "FLEXLINE 380"},
> > {"SUN", "CSM_100_R_FC"},
> >=20
> > The Flexline 380 is also now known as the Sun StorageTek 6540, and =
the
> > CSM_100_R_FC is also known as the Sun StorEdge 6130 - both are rebr=
anded
> > LSI arrays.
> >=20
> > --
> > Rick Brown
> > Office of Information Technology
> > Georgia Institute of Technology
> > 258 4th Street N.W.  Atlanta, GA  30332-0715
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> &#0;&#0;NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:=
+vwjm=07zZ+=DD=A2j"!

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
