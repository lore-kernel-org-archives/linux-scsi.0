From: Hannes Reinecke <hare@suse.de>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Wed, 28 Jun 2006 09:52:27 +0200
Message-ID: <44A2353B.1080105@suse.de>
References: <20060511143352.GI12272@parisc-linux.org>	 <20060518172258.GL1604@parisc-linux.org>	 <20060529031915.GB23405@parisc-linux.org>	 <447AB2F5.2000700@s5r6.in-berlin.de>	 <20060529130515.GE23405@parisc-linux.org>	 <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>	 <20060601132315.GD32143@parisc-linux.org>	 <1151270127.3617.26.camel@mulgrave.il.steeleye.com>	 <20060626205832.GC10505@austin.ibm.com> <1151356477.2673.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:55517 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030464AbWF1Hwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 03:52:47 -0400
In-Reply-To: <1151356477.2673.41.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linas Vepstas <linas@austin.ibm.com>, Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>

James Bottomley wrote:
> On Mon, 2006-06-26 at 15:58 -0500, Linas Vepstas wrote:
>> I guess there's no way of figuring out where the root disk is, and
>> waiting only for that?=20
>=20
> Well, sure, but you'd do that at user level:  you know what the root
> disk is, so you just wait on the udev event announcing its arrival.
>=20
Exactly. And it works well.

The only point left addressing is that you never know how long you=20
should be waiting. It would be nice if the transport class / SCSI ML=20
could give some hint somewhere to the effect 'scanning in progress'.
Otherwise you'll end up using arbitrary timeouts and you'll always find=
=20
machines where this timeout doesn't work :-(

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
