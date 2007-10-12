From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Update sysfs registration
Date: Fri, 12 Oct 2007 16:42:01 +0200
Message-ID: <470F87B9.2070604@suse.de>
References: <46F25D13.6020305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:44847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXJLOmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2007 10:42:04 -0400
In-Reply-To: <46F25D13.6020305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

Hi James,

I recently posted this patchset:

> these patches are a follow-up to the earlier patch from Kay Sievers n=
amed
> "[SCSI] switch sdev sysfs attributes to default attributes".
> It consists of three parts:
>=20
> - PATCH 1/3: Rework scsi target allocation so that uevents will only
>   be sent for existing targets
> - PATCH 2/3: Add scsi_bus type to scsi_target and scsi_host, so they
>   will show up in the scsi bus device listing.
> - PATCH 3/3: switch scsi_host sysfs attributes to default attributes
>=20
Did you have a chance to look at it?
Will that be included in 2.6.24?

Some other pending sysfs patches are based on this, so we'd rather like=
 to
know where we stand ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
