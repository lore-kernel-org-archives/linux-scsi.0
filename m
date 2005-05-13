From: Olaf Hering <olh@suse.de>
Subject: Re: Usage question
Date: Fri, 13 May 2005 12:43:03 +0200
Message-ID: <20050513104303.GA9697@suse.de>
References: <1112394885.6487.9.camel@localhost.localdomain> <424DFE79.4080003@s5r6.in-berlin.de> <1112450118.5518.3.camel@defiant> <1112492302.20936.12.camel@kino.dennedy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:47853 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262326AbVEMKnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 06:43:06 -0400
Content-Disposition: inline
In-Reply-To: <1112492302.20936.12.camel@kino.dennedy.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Dennedy <dan@dennedy.org>
Cc: Matthias =?utf-8?Q?Bl=C3=A4sing?= <mblaesing@gmx.de>, linux-scsi@vger.kernel.org, linux1394-user@lists.sourceforge.net

 On Sat, Apr 02, Dan Dennedy wrote:

> On Sat, 2005-04-02 at 15:55 +0200, Matthias Bl=C3=A4sing wrote:
> > Am Sa, den 02.04.2005 schrieb Stefan Richter um 4:07:
> > > ...CD/DVD-ROMs, because there are problems with device and host=20
> > > structures management if sr_mod of Linux 2.6 is involved. It is a=
n old=20
> > > known bug whose cause has not yet been figured out.
> >=20
> > There was a patch for the kernel on this list, which work quite goo=
d for
> > me (sr.c and sr_ioctl.c have to be modified - Olaf Hering on
> > 24.10.2004). I couldn't find any bad side effects of this.
>=20
> Thanks, I located the message on the linux1394-devel list:
> http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109862922621832=
&w=3D2
>=20
> There is a very good report response to Olaf's little patch.
> http://marc.theaimsgroup.com/?l=3Dlinux1394-devel&m=3D109925711513542=
&w=3D2
>=20
> Please, others, try it as well. I'm going to....

This patch is just a workaround.
ide-scsi shows exactly the same oops.=20
ide-scsi was fixed in 2.6.11 or 2.6.12, it should now have proper
refcounting. Someone has to implement the same for the sbp2 driver.
I cant help you with that challenge.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
