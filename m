From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch 02/17] Dell CERC support for megaraid_mbox
Date: Mon, 07 Apr 2008 14:44:40 +0200
Message-ID: <47FA1738.4020909@suse.de>
References: <9738BCBE884FDB42801FAD8A7769C26502085504@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:50988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbYDGMon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 08:44:43 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26502085504@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, "Patro, Sumant" <Sumant.Patro@lsi.com>

Yang, Bo wrote:
> Hannes,
>=20
> We can not find out why need to disable the random deletion of the
> logical drive for the FW version>=3D6.62?  Where is the 6.62 come fro=
m?
>=20
=46rom the bug reports we had. Dell machines with a fw rev < 6.61 work
with this driver, whereas newer rev (the said 6.62) don't.
As to the details: No idea. This is just what I found by comparing
the older megaraid driver (which worked, but is unsupported) and the
newer megaraid_mbox driver.
The noticeable difference was just the random deletion feature.
As I don't have any details about the driver I certainly can't
tell you any details. This is a workaround.
But as Dell (or LSI, for that matter) refuse to update the
BIOS on these drivers we're stuck with it.

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
