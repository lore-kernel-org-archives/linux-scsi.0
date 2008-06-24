From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/9] scsi_dh update
Date: Tue, 24 Jun 2008 12:11:26 +0200
Message-ID: <4860C84E.30601@suse.de>
References: <4860C65F.7080301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYFXKL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 06:11:27 -0400
In-Reply-To: <4860C65F.7080301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

Hannes Reinecke wrote:
> Hi James,
>=20
> this is the consolidated patchset to update the SCSI device_handler
> infrastructure. Features are:
>=20
[ .. ]
> Please apply.
>=20
And as a side note: I'm currently working on multiple driver
binding, so of course we can convert the device_handler to
a proper scsi driver once this is in place. But this is quite
tedious and time-consuming work and I'd really
like to see my patch queue reduced :-)

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
