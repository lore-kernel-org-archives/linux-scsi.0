From: Dan Dennedy <dan@dennedy.org>
Subject: Re: Usage question
Date: Sat, 02 Apr 2005 20:38:22 -0500
Message-ID: <1112492302.20936.12.camel@kino.dennedy.org>
References: <1112394885.6487.9.camel@localhost.localdomain>
	 <424DFE79.4080003@s5r6.in-berlin.de>  <1112450118.5518.3.camel@defiant>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nuvox.net ([64.89.70.9]:59848 "EHLO
	smtp05.gnvlscdb.sys.nuvox.net") by vger.kernel.org with ESMTP
	id S261419AbVDCBjE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 20:39:04 -0500
In-Reply-To: <1112450118.5518.3.camel@defiant>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias =?ISO-8859-1?Q?Bl=E4sing?= <mblaesing@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux1394-user@lists.sourceforge.net

On Sat, 2005-04-02 at 15:55 +0200, Matthias Bl=E4sing wrote:
> Am Sa, den 02.04.2005 schrieb Stefan Richter um 4:07:
> > ...CD/DVD-ROMs, because there are problems with device and host=20
> > structures management if sr_mod of Linux 2.6 is involved. It is an =
old=20
> > known bug whose cause has not yet been figured out.
>=20
> There was a patch for the kernel on this list, which work quite good =
for
> me (sr.c and sr_ioctl.c have to be modified - Olaf Hering on
> 24.10.2004). I couldn't find any bad side effects of this.

Thanks, I located the message on the linux1394-devel list:
http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109862922621832&w=
=3D2

There is a very good report response to Olaf's little patch.
http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109925711513542&w=
=3D2

Please, others, try it as well. I'm going to....



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
