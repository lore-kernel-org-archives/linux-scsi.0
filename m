From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re: Overlapped command error handling
Date: Sat,  4 Feb 2006 18:01:15 +0100
Message-ID: <IU69Y3$517F8D35A9CE9DEA507345F80BF13142@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:27186 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S932369AbWBDRBW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 12:01:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emmanuel.fuste" <emmanuel.fuste@laposte.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, hare <hare@suse.de>, "James.Bottomley" <James.Bottomley@SteelEye.com>

> Hello,
>=20
> Now compiling, results this evening.
> The patch for aic7xxx :
=2E..
> ---

Work, but cdrwtool -d /dev/sr0 -q completely freeze the
machine, no recovery possible this time, only the power button.
Will retry later...

Cheers,
Emmanuel.
---

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
