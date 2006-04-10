From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k
 of text
Date: Mon, 10 Apr 2006 12:00:59 +0200
Message-ID: <443A2CDB.5060404@suse.de>
References: <200604100844.12151.vda@ilport.com.ua> <200604100903.35431.eike-kernel@sf-tec.de> <200604101015.36869.vda@ilport.com.ua> <200604100919.23244.eike-kernel@sf-tec.de> <443A2805.6000806@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:7133 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751111AbWDJKBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 06:01:12 -0400
In-Reply-To: <443A2805.6000806@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Denis Vlasenko <vda@ilport.com.ua>, SCSI List <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, gibbs@scsiguy.com

Stefan Richter wrote:
> Rolf Eike Beer wrote:
>> Denis Vlasenko wrote:
>>> I am leaving it up to maintainer to decide. After all, the driver
>>> is for multiple OSes, other OS may lack mdelay().
>> The comment says about multiple milliseconds sleeps which just don't=
 happen.
>=20
> Given what ah{c,d}_delay are (OS dependent wrappers) and how they are
> used (definitely not for multi-msec delays), they should just be chan=
ged
> into a #define ah{c,d}_delay(us) udelay(us) or into void inline
> ah{c,d}_delay(long us) {udelay(us);}.

I'd rather do a #define. Inlining simple functions is quite unneccessar=
y
here.

Re multiplatform development: aic7{9,x}xx have ceased to be
multiplatfrom since the integration of scsi_transport_spi.
So I wouldn't worry too much about it.

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
