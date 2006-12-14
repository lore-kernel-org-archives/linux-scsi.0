From: Hannes Reinecke <hare@suse.de>
Subject: Re: aic79xx - wrong max memory at driver init
Date: Thu, 14 Dec 2006 11:37:42 +0100
Message-ID: <45812976.4090000@suse.de>
References: <456EBB83.9010300@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39030 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbWLNKuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Dec 2006 05:50:07 -0500
In-Reply-To: <456EBB83.9010300@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: xb <xavier.bru@bull.net>, linux-scsi@vger.kernel.org

=46rederic TEMPORELLI wrote:
> Hello Hannes,
>=20
> Aic79xx driver for Adaptec 39320 supports 64-bit addressing, but the
> initialization code of the driver is wrong: it tests the available
> memory size instead of testing the maximum available memory address.
> This is necessary to support servers that provides 1 Terabyte of
> physical memory space addressing.
>=20
> Attached is the suggested patch (made against 2.6.17, but 2.6.19 is
> still using the available memory size instead of using the max memory
> address) to solve this issue.
>=20
> regards
>=20
> --
> Fred
>=20
>=20
Yes, this sound reasonable.

> ---------------------------------------------------------------------=
---
>=20
> Signed-off-by: xavier.bru@bull.net
> Signed-off-by: frederic.temporelli@bull.net
>=20
Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
