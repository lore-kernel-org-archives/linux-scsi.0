From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
Date: Sat, 23 Oct 2010 12:41:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1010231240080.3849-100000@netrider.rowland.org>
References: <927255.77335.qm@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:54763 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757984Ab0JWQl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 12:41:58 -0400
In-Reply-To: <927255.77335.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Luben Tuikov wrote:

> --- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Yeah, the new one is better.=A0 I would have preferred
> > to see fm_ili=20
> > explained in a comment, but this is okay.
>=20
> Thanks. I tried to preserve the logic and the comments as much as pos=
sible and tried not to introduce neither additional comment nor additio=
nal logic. Is this an implicit ACK then? Or does Greg needs an explicit=
 one?  Will he or I have to ask for an explicit ACK? From whom else?

You may consider it an ACK from me.  However this needs to be approved=20
by the usb-storage maintainer.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
