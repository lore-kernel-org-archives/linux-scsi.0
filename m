From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.39 and Powerfile c200
Date: Mon, 30 May 2011 23:24:29 +0200
Message-ID: <20110530232429.3ef05054@stein>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
	<20110528202646.02280a95@stein>
	<BANLkTi=JUTZ+7DNNZJR5wpODes78tYPVjA@mail.gmail.com>
	<BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56337 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1E3VYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2011 17:24:42 -0400
In-Reply-To: <BANLkTin=kaUtYMi7QeEAJmSLvLm7rmADkQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Isom <jeisom@gmail.com>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On May 30 Jonathan Isom wrote:
> > On Sat, May 28, 2011 at 1:26 PM, Stefan Richter
> >> Was the 2.6.39 kernel update the only change that you did on your =
system,
> >> or were there userland updates too? =C2=A0If yes, maybe you have a=
 program now
> >> that sends weird commands that crash the Powerfile's firmware.
[...]
>=20
>    Well I messed around with it on the mac.  It works fine with it.  =
Could
> this be a firewire board failure or is it more indicative of a softwa=
re bug?

=46ireWire board failures usually cause some more pronounced I/O errors=
 than
mere SCSI request time-outs; so while it is a possible cause, it is a
rather unlikely one.

> You mentioned updates to software.  What packages would you suggest
> I look besides udev?

If there is hal(d) on your system, shut this service down and retry.

Another thought:  Which FireWire controller do you have according to
lspci -nn?
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D=3D -=3D-=3D =3D=3D=3D=3D-
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
