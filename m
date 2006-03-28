From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
Subject: Re:[PATCH 0/5] AIC7xxx port of latests AIC79xx patchs
Date: Tue, 28 Mar 2006 21:32:18 +0200
Message-ID: <IWURLU$9A7E79C7D8BCF1A9AE8A8B540822E5C2@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:27016 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1751287AbWC1Tcl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 14:32:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emmanuel.fuste" <emmanuel.fuste@laposte.net>
Cc: hare <hare@suse.de>, "James.Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

> Hello,
>=20
> I port latest Hannes Reinecke patchs to aic7xxx.
> Compile tested only, runtime report later.
>=20
Ok,
As you could see all work fine.
Now it will be time to triger the recovery part.
Will now try the killer cmd: cdrwtools -d /dev/scd0 -q

Emmanuel.


Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
