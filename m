From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Mon, 13 Mar 2006 14:33:53 +0100
Message-ID: <441574C1.2070207@suse.de>
References: <440D8B7C.9020001@ext.bull.net> <20060310164027.GA6397@infradead.org> <20060310182032.GA1841@redhat.com> <1142015990.2876.94.camel@laptopd505.fenrus.org> <20060310191619.GC1841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:38367 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932068AbWCMNd6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Mar 2006 08:33:58 -0500
In-Reply-To: <20060310191619.GC1841@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Doug Ledford wrote:
[ .. ]
> Not for the card driver.  Not to speak for the aic7xxx, but at least =
in the
> aic7xxx_old driver, on QUEUE_FULL, my driver did the following things=
:
>=20
[ Lots of instructive text deleted ]
>=20
> After clearing all that stuff out, then and only then do I have an ac=
curate
> count of what depth the device was at when it sent a QUEUE_FULL.
>=20
Thanks Doug, that was exactly that bit of information I was looking for=
=2E
Currently this mechanism doesn't work anymore with aic79xx and now I
have to figure out what I've broken during upgrade. Your description
will come in handy here.

Thanks a lot :-)

Cheers,

Hannes
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
