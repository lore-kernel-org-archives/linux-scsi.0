From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/17] lpfc: Use new FDMI speed definitions for 10G, 25G and 40G FCoE.
Date: Thu, 17 Dec 2015 17:05:12 +0100
Message-ID: <2071827.nYQf9Y0n6W@lennox.hannes-reinecke.de>
References: <5671efc2.Tcr1T+jB8naNKSFQ%james.smart@avagotech.com> <56727313.6010301@suse.de> <5672DCC9.4060901@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbbLQQFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 11:05:14 -0500
In-Reply-To: <5672DCC9.4060901@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org

On Thursday, December 17, 2015 08:03:21 AM James Smart wrote:
> On 12/17/2015 12:32 AM, Hannes Reinecke wrote:
> > Ah. So here is the missing 32G speed.
> >=20
> > Should be moved into the 'Fix RDP Speed reporting' patch, no?
>=20
> which of these 2 patches is not that meaningful.
>=20
Yeah, and not that big deal.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		 zSeries & Storage
hare@suse.de		+49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
