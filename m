From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] use spi_transport_class for aic79xx
Date: Thu, 09 Jun 2005 10:27:38 +0200
Message-ID: <42A7FD7A.1050105@suse.de>
References: <42A7EAEA.3060302@suse.de> <42A7F5A7.5080401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:56514 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262333AbVFII1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2005 04:27:41 -0400
In-Reply-To: <42A7F5A7.5080401@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Hannes Reinecke wrote:
>> Hi James,
>>
>> you asked for it :-)
>> This patch updates aic79xx to use the spi transport class.
>> Wasn't even too hard.
>> Patch is relative to 2.6.12-rc6 + scsi-misc fixes.
>>
>> Comments etc. welcome.
>> Otherwise please apply.
>=20
> Very nice, you saved me some work.
>=20
Thought so.

> And, did you test it?  :)
>=20
Ach, you don't trust me?

Seriously, yes I did test it here (Adaptec ASC-29320 U320).
The usual error applies (crashes on rmmod when disk-devices are
attached, removing devices by hand and rmmod afterwards works, though),
but apart from it seems to work.
And if not I can always blame the transport layer for it :-).
Next step is to connect an U320 drive to check it works properly.

> I would like to merge this with my aic changes (ports of James B's
> aic7xxx work), which removes the busyq, and soon, the completeq.
>=20
As it happens I've just merged you aic branch with my update, so watch
this space. Next step is to include James' latest changes to aic7xxx
into the aic79xx also.

And I _really_ like to see the common parts merged.
Both drivers share a lot of code.

> See the 'aic' branch of
> rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.gi=
t
>=20
See above. And it only took me 4hrs to figure out the git stuff ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
