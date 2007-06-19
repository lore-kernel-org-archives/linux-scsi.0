From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 19 Jun 2007 10:28:42 +0200
Message-ID: <467793BA.6000905@suse.de>
References: <200706191025.30986.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbXFSI2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 04:28:48 -0400
In-Reply-To: <200706191025.30986.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, christof.schmitt@de.ibm.com

Swen Schillig wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
>=20
> When reporting SCSI devices to the SCSI midlayer, use the FCP LUN as
> LUN reported to the SCSI layer. With this approach, zfcp does not hav=
e
> to create unique LUNS, and this code can be removed.
>=20
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
>=20
Grand. Another zfcp-ism removed.

=46WIW:

Signed-off-by: Hannes Reinecke <hare@suse.de>

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
