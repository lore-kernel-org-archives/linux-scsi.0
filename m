From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Protect against overflow in dev_loss_tmo
Date: Fri, 26 Mar 2010 10:50:17 +0100
Message-ID: <4BAC8359.7020106@suse.de>
References: <4BA1AB14.6020600@cs.wisc.edu> <20100322141239.GB6953@schmichrtp.mainz.de.ibm.com> <20100324160231.GA26364@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46899 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0CZJuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2010 05:50:19 -0400
In-Reply-To: <20100324160231.GA26364@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Christof Schmitt wrote:
[ .. ]
>=20
> I just posted the complete version of the patch and the adaption of
> zfcp:
> http://marc.info/?l=3Dlinux-scsi&m=3D126944631211269&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D126944631211272&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D126944631611276&w=3D2
>=20
> Any comments about this approach for unblocking the scsi eh thread?
>=20
That looks like a really good idea. And it might even solve the problem
we had with path flapping on a multipathed raid device.
I'll give it a go here locally.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
