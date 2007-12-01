From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Sat, 1 Dec 2007 10:55:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712011053060.21477-100000@netrider.rowland.org>
References: <1196519099.5977.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2872 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113AbXLAPzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Dec 2007 10:55:44 -0500
In-Reply-To: <1196519099.5977.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Sat, 1 Dec 2007, James Bottomley wrote:

> On Thu, 2007-11-29 at 15:18 -0800, Andrew Morton wrote:
> > Guys, I have this marked as needed-in-2.6.24?
>=20
> Could you wait on this a bit ... since it's such an old bug.  The cod=
e
> in question needs to be reworked (as the comment says).  I think the
> best rework is to have the caller pass in an optional struct
> scsi_sense_header into scsi_test_unit_ready() instead of the hacky
> media_may_be_present, so the one place that needs this will be able t=
o
> interpret the sense codes correctly.
>=20
> I can do this when I get back home ... unfortunately, I'm in Aswan to=
day
> at an Internet caf=C3=A9 ... I'll be back in Cairo tomorrow, but my U=
S system
> seems to have fallen off the internet, so I might not be able to test
> any patches I come up with.  Worst case, I'll be back in Chicago on
> Thursday.

That's fine with me.  But the optional scsi_sense_header should be=20
added in two places, not just one: There's the medium-detection code in=
=20
sr.c already in this patch, and there's the medium-detection code in=20
sd.c (it was changed in my original patch but not in this one).

Alan Stern

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
