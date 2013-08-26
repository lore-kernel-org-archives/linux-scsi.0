From: Ben Collins <bcollins@ubuntu.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 16:26:30 -0400
Message-ID: <AA2AC8A7-DD06-4AC5-9E4D-E522F6AC1B09@ubuntu.com>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com> <yq1zjskgn1x.fsf@sermon.lab.mkp.net> <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com> <yq1eh9wgiqo.fsf@sermon.lab.mkp.net> <FE68512D-F375-456B-948A-492634A02F0F@servergy.com> <yq1haeqcuce.fsf@sermon.lab.mkp.net> <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com> <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com> <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com> <20130826090540.GA26892@infradead.org> <EB4C61A1A2501842A04B573FE42B14D6029EDD85EC@cosmail02.lsi.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E17E65F2-B995-481A-812E-897FE98C5DBB"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40492 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3HZU0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 16:26:33 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so3905461pde.37
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:26:33 -0700 (PDT)
In-Reply-To: <EB4C61A1A2501842A04B573FE42B14D6029EDD85EC@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Maloy, Joe" <Joe.Maloy@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maly, JoLyn" <JoLyn.Maly@lsi.com>


--Apple-Mail=_E17E65F2-B995-481A-812E-897FE98C5DBB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 26, 2013, at 4:15 PM, "Maloy, Joe" <Joe.Maloy@lsi.com> wrote:
> Chris,
>=20
> I would appreciate you toning down your rhetoric.  Please keep it =
professional.
>=20
> What Sumit reported is correct.  We are polling our Marketing and =
Product management organizations to see if we want to productize this =
type of support in our MR Linux drivers. We would not submit upstream =
changes that have not been successfully tested by our PT test org based =
on a GCA (general customer availability) or async release effort.

Professionally speaking, however, having the megaraid_sas driver support =
big-endian is inline with the requirements of the driver being in the =
kernel tree to begin with. This support was promised 8 years back by =
LSI. Quite frankly, I can't imagine that LSI has to approve of this =
support before it can be included into the kernel proper. If LSI doesn't =
want to support big-endian, that's fine with me. However, if the =
community wants to support it in a public driver, I don't think LSIs =
Product Management and Marketing teams have anything useful to say about =
it.

a) This driver doesn't work on big-endian
b) This patch supports more architectures
c) This patch doesn't break existing architecture support (not even that =
which LSI wants to support)

Not including this patch does nothing useful. Including it will put =
megaraid_sas on the path to doing what every driver in the tree either =
does or attempts to do, and more important, should do.

Historically, waiting on commercial upstream to deliver what the =
community has already done is wasted time. Likewise, historically, =
allowing patches that partially implement things (in this respect, =
support one generation of card for megaraid_sas) leads to further =
support from the community, in a much faster timeframe.

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/


--Apple-Mail=_E17E65F2-B995-481A-812E-897FE98C5DBB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iEYEARECAAYFAlIbufYACgkQbVJJsWDoC1tFHQCePLVa9FUSCSkctPMzV4PGa8oI
/UYAnRlNzz+R2e/JfuvGXe6KIvJ4QMdG
=A39M
-----END PGP SIGNATURE-----

--Apple-Mail=_E17E65F2-B995-481A-812E-897FE98C5DBB--
