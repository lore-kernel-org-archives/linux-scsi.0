From: Greg KH <greg@kroah.com>
Subject: Re: [BK PATCH] SCSI update for 2.6.3
Date: Tue, 24 Feb 2004 09:04:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224170412.GA31268@kroah.com>
References: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:44431 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262306AbUBXREY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:04:24 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402240919490.1129@spektro.metla.fi>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@metla.fi>
Cc: Linus Torvalds <torvalds@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, kai.makisara@kolumbus.fi

On Tue, Feb 24, 2004 at 09:30:01AM +0200, Kai Makisara wrote:
> On Tue, 24 Feb 2004, Linus Torvalds wrote:
> >On Mon, 23 Feb 2004, James Bottomley wrote:
> >>
> >> Kai M=E4kisara:
> >> o Sysfs class support for SCSI tapes
> >
> >Has this been checked for correctness, or will Al flame me to a cris=
p for
> >accepting it? Pls verify..
>=20
> It is using the class_simple interface Greg KH said can be used witho=
ut
> changes to driver's lifetime rules. If this is not true, then I have =
to
> rework the patch. The code was posted to linux-scsi on Feb 5 but I wo=
uld
> not count on any serious review being done there.

Can you post it here so we can review it?

And yes, using class_simple should relieve you of Al flamage :)

thanks,

greg k-h
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
