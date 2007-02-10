From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Fri, 09 Feb 2007 20:02:42 -0600
Message-ID: <1171072962.3627.81.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0702091251350.4548-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44670 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753108AbXBJFSe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Feb 2007 00:18:34 -0500
In-Reply-To: <Pine.LNX.4.44L0.0702091251350.4548-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, dgilbert@interlog.com, dougg@torque.net, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, schilling@fokus.fraunhofer.de, Jens Axboe <Jens.Axboe@oracle.com>

On Fri, 2007-02-09 at 12:57 -0500, Alan Stern wrote:
> > it's 2 monts that we did discuss this problem.
> > Has the solution integrated into the Linux kernel?
> >=20
> > J=C3=B6rg
>=20
> Not yet.  Despited repeated inquiries, I still haven't heard anything=
 back=20
> from James regarding the patch that he wrote.
>=20
> James, if you prefer I can send that patch to Andrew Morton.  Would t=
hat=20
> be easier for you?

Actually, the patch I wrote was a block patch, so it goes through Jens'
tree.

I know he had it a while ago ... but I'm afraid there's a bit of a
fundamental breakdown in the usual open source process because the
author (unfortunately me) should be tracking it, and I'm not really ...
if it were my tree, I would probably have just slipped it in to prevent
my forgetting about it, but it isn't.

I added Jens to the cc list, so he can probably tell us what happened t=
o
it.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
