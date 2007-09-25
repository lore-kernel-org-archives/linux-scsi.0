From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Tue, 25 Sep 2007 17:11:00 +0200
Message-ID: <200709251711.01216.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:52295 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbXIYPKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 11:10:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Dienstag 25 September 2007 schrieb Alan Stern:
> > Furthermore for many devices it will take real user intervention to
> > determine what is in the enclosure. This isn't very good. I think
> > we can do better.
>=20
> If by "we" you mean the Linux kernel in general, then I agree. =A0If =
by
> "we" you mean the USB developers, then I disagree. =A0Help is needed =
from
> the SCSI people.

I am working on it. It seems to me that all necessary functions exist.

	Regards
		Oliver

PS: Whoever designed klists is suffering from a case of overengineering=
osis.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
