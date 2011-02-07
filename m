From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Why using configfs as the only interface is wrong for a storage
 target
Date: Mon, 7 Feb 2011 16:02:23 +0100
Message-ID: <20110207160223.598210a2@harpe.intellique.com>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	<20110207115347.GA7503@noexit>
	<1297089709.3012.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:33344 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1BGPCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 10:02:25 -0500
In-Reply-To: <1297089709.3012.19.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>, Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

Le Mon, 07 Feb 2011 08:41:49 -0600
James Bottomley <James.Bottomley@suse.de> =E9crivait:

> I think the overall philosophical point here, and it's a good one
> because I've heard it from several sources, is that it's not possible
> to separate configuration from status completely.=20

This would be true only if the machines weren't ever rebooted. Out of
this uncommon case, this is even worse than the previous state of the
matter : instead of having a (eventually nice, human readable)
configuration file, you need a real program to create dynamically the
devices at boot time, which is therefore your ACTUAL configuration
file. So all you're achieving with this philosophy is replacing data
files by programs -- anyone but kernel programmers will find this a
terrible idea.

Then to avoid the hassle, someone will have the clever idea to build a
way to load an INI file into configfs through a specially crafted
program living in /etc/init.d, and we'll have been going full circle.
Slow clap... This is the most brain-dead idea I've heard of in a long
time.

configfs would be a good idea only if the kernel could make it
transparently persistent. Until that happens, it's a near perfect
administor pet peeve.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
