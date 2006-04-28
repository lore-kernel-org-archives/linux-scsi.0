From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: Re: Re:[PATCH 0/5] AIC7xxx port of latests AIC79xx patchs
Date: Fri, 28 Apr 2006 16:37:34 +0200
Message-ID: <IYFSMM$5E5B7483695B4FB653014150338B475B@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:9863 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S965213AbWD1Oih convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 10:38:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@SteelEye.com>
Cc: hare <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

> On Tue, 2006-03-28 at 21:32 +0200, Emmanuel Fust=E9 wrote:
> > > Hello,
> > >=20
> > > I port latest Hannes Reinecke patchs to aic7xxx.
> > > Compile tested only, runtime report later.
> > >=20
> > Ok,
> > As you could see all work fine.
> > Now it will be time to triger the recovery part.
> > Will now try the killer cmd: cdrwtools -d /dev/scd0 -q
>=20
> Is there any update on this ... like have you actually
tested with
> actual hardware?
>=20
My computer is running fine with these six patches applied
since last month.
I did not have access to other hardware to test it.

As you could have seen in a previous mail, I have no
regressions on my hardware and it made things better with my
cdrw problem (but it does not fix it).

Emmanuel.

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
