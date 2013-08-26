From: Ben Collins <bcollins@ubuntu.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Mon, 26 Aug 2013 19:22:49 -0400
Message-ID: <149C3F21-653C-4C29-BB99-F22F9E3C38BC@ubuntu.com>
References: <yq1zjskgn1x.fsf@sermon.lab.mkp.net> <D354E621-BEFA-4010-B5CF-4668939AAEB0@servergy.com> <yq1eh9wgiqo.fsf@sermon.lab.mkp.net> <FE68512D-F375-456B-948A-492634A02F0F@servergy.com> <yq1haeqcuce.fsf@sermon.lab.mkp.net> <088E451FE1854947BD9145EF8C016FF413A017B456@inbmail01.lsi.com> <3DA40821-A3AC-45CA-BD22-995EA256837A@servergy.com> <088E451FE1854947BD9145EF8C016FF413A017BC30@inbmail01.lsi.com> <20130826090540.GA26892@infradead.org> <EB4C61A1A2501842A04B573FE42B14D6029EDD85EC@cosmail02.lsi.com> <20130826204137.GA26624@infradead.org> <EB4C61A1A2501842A04B573FE42B14D6029EDD8661@cosmail02.lsi.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3638518D-8A46-4E8F-A1F5-BFDCC7CB119D"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37828 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3HZXWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 19:22:47 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so4048946pad.33
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 16:22:46 -0700 (PDT)
In-Reply-To: <EB4C61A1A2501842A04B573FE42B14D6029EDD8661@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Maloy, Joe" <Joe.Maloy@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "aradford@gmail.com" <aradford@gmail.com>, "Maly, JoLyn" <JoLyn.Maly@lsi.com>


--Apple-Mail=_3638518D-8A46-4E8F-A1F5-BFDCC7CB119D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> We have done a code review of what has been proposed and we believe it =
is incomplete.  We don't think that in its current state it will serve =
Linux as well as we all want it to.


I fully appreciate you're intent, but I can't imagine how you can think =
that it wont serve Linux in it's current state when it does in fact =
serve Linux (and its users) in it's current state.

What doesn't serve Linux (and its users) is blocking patches in the =
hopes of you taking two weeks to get two non-technical departments to =
approve you and/or some other engineer(s) to do what you consider a =
better job. You cannot guarantee that this will even be "approved" and =
you can't guarantee that the end will result will come at any reasonable =
point in time after that arbitrary waiting period.

The delay serves no purpose. LSIs solution to this problem with only be =
a superset of this patch. This patch will be unchanged from your =
solution because there is absolutely no other way to implement this. =
It's not like there is a technical discussion about how the patch works. =
It's plain and simple.

So I say include this patch. If you get some sort of ok by your bobbling =
heads to complete the work, then you can even tell them "it's partly =
done already." No manager can argue with less work (aka investment).

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/


--Apple-Mail=_3638518D-8A46-4E8F-A1F5-BFDCC7CB119D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iEYEARECAAYFAlIb40kACgkQbVJJsWDoC1vgrgCgtXIakPXMbuI23M9dh2kDeojv
fhQAniK8l/dQsWAk04Om3B5UP+APTiRh
=AUuV
-----END PGP SIGNATURE-----

--Apple-Mail=_3638518D-8A46-4E8F-A1F5-BFDCC7CB119D--
