From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Asynchronous Event Reporting
Date: Wed, 17 Apr 2002 09:43:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CBD7C14.18E546CC@torque.net>
References: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D24@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Heinz, Michael" <mheinz@infiniconsys.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, linux-scsi@vger.kernel.org

Michael,
Yes I believe you are correct.

Sounds like an interesting challange, though.

Doug Gilbert


"Heinz, Michael" wrote:
>=20
> Well, the fact that no one has answered either one of us would indica=
te
> that, no, there is no way to pass AER data to the mid layer...
>=20
> --
> Now, where is that clue? I know I had one a minute ago....
> --
> mheinz@infiniconsys.com
>=20
> > -----Original Message-----
> > From: Martin Peschke3 [mailto:MPESCHKE@de.ibm.com]
> > Sent: Tuesday, April 16, 2002 9:00 AM
> > To: Heinz, Michael
> > Cc: linux-scsi@vger.kernel.org
> > Subject: Re: Asynchronous Event Reporting
> >
> >
> > Hi,
> >
> > is there any transfer mechanism which allows an HBA driver to push
> > its AER data to the mid layer?
> >
> > Mit freundlichen Gr=FC=DFen / with kind regards
> >
> > Martin Peschke
> >
> > IBM Deutschland Entwicklung GmbH
> > Linux for eServer Development
> > Phone: +49-(0)7031-16-2349
> >
> >
> > Michael Heinz <mheinz@infiniconsys.com>@vger.kernel.org on 04/16/20=
02
> > 02:30:34 PM
> >
> > Please respond to Michael Heinz <mheinz@infiniconsys.com>
> >
> > Sent by:    linux-scsi-owner@vger.kernel.org
> >
> >
> > To:    linux-scsi@vger.kernel.org
> > cc:
> > Subject:    Asynchronous Event Reporting
> >
> >
> >
> > I'd like to do a quick sanity check here...
> >
> > I've been asked to make sure I support async event reporting in the
> > driver I'm working on (which will eventually be GPL! Honest! :-P).
> >
> >  From reviewing the code in 2.4 scsi/drivers it appears that
> > the best I
> > can do is log that I got the event, but then ignore it - sd.c does =
not
> > support AER.
> >
> > Is this correct?
> >
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
