From: Luciano Rocha <luciano@eurotux.com>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Wed, 5 Nov 2008 10:26:14 +0000
Message-ID: <20081105102614.GB3586@bit.office.eurotux.com>
References: <20081103155254.GA3368@bit.office.eurotux.com> <Pine.LNX.4.44L0.0811031444130.2194-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from os.eurotux.com ([216.75.63.6]:37133 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYKEK0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2008 05:26:21 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811031444130.2194-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 03, 2008 at 02:46:38PM -0500, Alan Stern wrote:
> On Mon, 3 Nov 2008, Luciano Rocha wrote:
>=20
> > On Tue, Oct 28, 2008 at 01:38:11PM -0400, Alan Stern wrote:
> > > > Do you wish me to test anything else?
> > >=20
> > > Yes.  Please post a usbmon trace for each of the last two tests. =
 That=20
> > > is, with the unusual_devs update only, and with the unusual_devs =
update=20
> > > plus the invoke_transport update and the scsi_requeue_command upd=
ate.
> >=20
> > I've updated the bugzilla entry with traces for some combinations o=
f the
> > discussed patches:
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D11843
>=20
> Okay, thanks.  I see the problem.  This whole area is a mess, and it'=
s=20
> going to be different in 2.6.28.  But for now...
>=20
> Please rerun the A+B and A+B+C tests, but this time using the B' patc=
h
> below instead of B.

New test data in the bugzilla.

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
