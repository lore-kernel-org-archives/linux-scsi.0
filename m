From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: RE: Asynchronous Event Reporting
Date: Wed, 17 Apr 2002 09:37:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D24@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Well, the fact that no one has answered either one of us would indicate
that, no, there is no way to pass AER data to the mid layer...


--
Now, where is that clue? I know I had one a minute ago....
--
mheinz@infiniconsys.com


> -----Original Message-----
> From: Martin Peschke3 [mailto:MPESCHKE@de.ibm.com]
> Sent: Tuesday, April 16, 2002 9:00 AM
> To: Heinz, Michael
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: Asynchronous Event Reporting
>=20
>=20
> Hi,
>=20
> is there any transfer mechanism which allows an HBA driver to push
> its AER data to the mid layer?
>=20
> Mit freundlichen Gr=FC=DFen / with kind regards
>=20
> Martin Peschke
>=20
> IBM Deutschland Entwicklung GmbH
> Linux for eServer Development
> Phone: +49-(0)7031-16-2349
>=20
>=20
> Michael Heinz <mheinz@infiniconsys.com>@vger.kernel.org on 04/16/2002
> 02:30:34 PM
>=20
> Please respond to Michael Heinz <mheinz@infiniconsys.com>
>=20
> Sent by:    linux-scsi-owner@vger.kernel.org
>=20
>=20
> To:    linux-scsi@vger.kernel.org
> cc:
> Subject:    Asynchronous Event Reporting
>=20
>=20
>=20
> I'd like to do a quick sanity check here...
>=20
> I've been asked to make sure I support async event reporting in the
> driver I'm working on (which will eventually be GPL! Honest! :-P).
>=20
>  From reviewing the code in 2.4 scsi/drivers it appears that=20
> the best I
> can do is log that I got the event, but then ignore it - sd.c does no=
t
> support AER.
>=20
> Is this correct?
>=20
> --
> knock knock.
>=20
> Michael Heinz <mheinz@infiniconsys.com>
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
