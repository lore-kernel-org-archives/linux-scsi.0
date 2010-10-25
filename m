From: Hannes Reinecke <hare@suse.de>
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 16:30:27 +0200
Message-ID: <4CC59483.3070201@suse.de>
References: <20101023095816.GA19791@apartia.fr> <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com> <20101025131937.GA6605@apartia.fr> <20101025154705.73d49860@harpe.intellique.com> <20101025135647.GA14302@apartia.fr> <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com> <20101025140905.GA20569@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JYO3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 10:29:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 8A0B28730A
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 16:29:45 +0200 (CEST)
In-Reply-To: <20101025140905.GA20569@apartia.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/25/2010 04:09 PM, Louis-David Mitterrand wrote:
> On Mon, Oct 25, 2010 at 08:02:22AM -0600, Yang, Bo wrote:
>> You also can use ctrl^H during the controller post to configure the =
JBOD. =20
>=20
> Unfortuntely I found no way to configure disks in JBOD mode through t=
he
> adapter bios. A google search seems to indicate other users have the
> same problem.
>=20
> Apparently a firmware change (to "initiator and target" mode) is
> required to turn that adapter's into a simple non-raid SATA controlle=
r
> but I couldn't find it anywhere.
>=20
Bzzt. Nope.
IT firmware is for the 'plain' mptsas (LSI SAS 1078) only.
PERC6/i is based upon the 'Megaraid' SAS 1078, which is using the
same SAS chip but has an additional (hardware) RAID controller.

You cannot change the firmware here.

And yes, megacli is notoriously tricky to invoke.
It really needs to get used to.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
