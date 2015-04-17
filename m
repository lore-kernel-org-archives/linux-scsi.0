From: Hannes Reinecke <hare@suse.de>
Subject: Re: [GIT PULL] SCSI updates for the 4.0+ merge window
Date: Fri, 17 Apr 2015 08:51:17 +0200
Message-ID: <5530AD65.804@suse.de>
References: <1429205677.2196.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbbDQGvU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 02:51:20 -0400
In-Reply-To: <1429205677.2196.23.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 04/16/2015 07:34 PM, James Bottomley wrote:
> This is the usual grab bag of driver updates (lpfc, qla2xxx, storvsc,
> aacraid, ipr) plus an assortment of minor updates.  There's also a ma=
jor
> update to aic1542 which moves the driver into this millenium.
>=20
> The patch is available here:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
>=20
What about my patch to fixup am53c974 (cf "am53c974: Fix crash
during modprobe")?

Do I need to resend it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
