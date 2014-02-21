From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Fri, 21 Feb 2014 07:46:41 +0100
Message-ID: <5306F651.6050607@suse.de>
References: <1392800681-5290-1-git-send-email-mlombard@redhat.com>	<530474D2.4050504@suse.de> <5304780A.6020605@redhat.com>	<53047DA0.4030100@suse.de> <yq1ob21k2ng.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbaBUGqn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Feb 2014 01:46:43 -0500
In-Reply-To: <yq1ob21k2ng.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, jbottomley@parallels.com
Cc: Maurizio Lombardi <mlombard@redhat.com>, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org, kay@vrfy.org

On 02/20/2014 08:25 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes,
>=20
>>> If you have a more complete and up-to-date patchset in your queue i=
t
>>> would be interesting to have a look at it.
>>>
> Hannes> You can find the current development branch at
>=20
> Hannes> git.kernel.org:/pub/scm/linux/kernel/git/hare/scsi-devel bran=
ch
> Hannes> scsi-logging.v3
>=20
> I like the printk cleanups and the more sensible sense printing. But =
why
> perpetuate the crufty old SCSI logging stuff when we have SCSI tracin=
g?
>=20

I'm all for removing it, and move over to SCSI tracing.
But not without general (read: the maintainers) consent.

James?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
