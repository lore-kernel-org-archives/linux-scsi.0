From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Wed, 08 Feb 2006 11:52:32 +0100
Message-ID: <43E9CD70.8010408@suse.de>
References: <IUD5WB$FD60BECFC5D6F5FC6C05445B9285B6E2@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:64980 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030354AbWBHKwu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 05:52:50 -0500
In-Reply-To: <IUD5WB$FD60BECFC5D6F5FC6C05445B9285B6E2@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@laposte.net>
Cc: hch <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Emmanuel Fust=E9 wrote:
>> On Tue, Feb 07, 2006 at 12:30:55PM +0100, Hannes Reinecke wrote:
>>> As in
>>>
>>> void
>>> ahd_freeze_simq(struct ahd_softc *ahd)
>>> {
>>> 	scsi_block_requests(ahd->platform_data->host);
>>> }
>>>
>>> ?
>> Yes.
>>
> Does it mean we could simply remove the platform_data->qfrozen
> flag/counter ?
>=20
>=20
Yes. I'll send an updated patchset around.

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
