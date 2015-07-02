From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH] st: null pointer dereference panic caused by use after kref_put by st_open
Date: Thu, 02 Jul 2015 15:11:38 +0200
Message-ID: <mqdfv564sc5.fsf@c203.arch.suse.de>
References: <DDB9C85B850785449757F9914A034FCB44430852@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbbGBNLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 09:11:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>, "Lavender, Darren Christopher" <darren.lavender@hp.com>

"Seymour, Shane M" <shane.seymour@hp.com> writes:

> Two SLES11 SP3 servers encountered similar crashes simultaneously
> following some kind of SAN/tape target issue:
>

Thanks,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
