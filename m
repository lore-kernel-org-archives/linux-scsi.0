From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] aic79xx: SLOWCRC fix
Date: Tue, 24 Jan 2006 10:57:35 +0100
Message-ID: <43D5FA0F.6040901@suse.de>
References: <43D5F706.30009@suse.de> <1138096403.2977.36.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:15059 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1030432AbWAXJ5l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:57:41 -0500
In-Reply-To: <1138096403.2977.36.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Arjan van de Ven wrote:
> On Tue, 2006-01-24 at 10:44 +0100, Hannes Reinecke wrote:
>>  	/*
>> +	 * Slow down our CRC interval to be
>> +	 * compatible with packetized U320 devices
>> +	 * that can't handle a CRC at full speed
>> +	 */
>> +	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
>> +		con_opts |=3D ENSLOWCRC;
>> +	}
>=20
> since this seems to be a device quirk, shouldn't this just be part of
> the scsi blacklist and have a quirk there? Maybe with a generic optio=
n
> to trigger that quirk as well rather than a per driver module one...
>=20
Errm.

blacklisting is for device only, not for HBAs, or?
This slowcrc is a fix for buggy adaptec hardware. Nothing to do with th=
e
devices connected to it...

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
