From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Switch some more scsi drivers to pci_get_device
 and refcounted pci structures
Date: Tue, 19 Sep 2006 10:32:37 +0200
Message-ID: <450FAB25.3010303@suse.de>
References: <1158330872.29932.61.camel@localhost.localdomain> <20060918190155.GE17670@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35771 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932287AbWISIcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 04:32:53 -0400
In-Reply-To: <20060918190155.GE17670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 15, 2006 at 03:34:32PM +0100, Alan Cox wrote:
>> Signed-off-by: Alan Cox <alan@redhat.com>
>>
>> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux=
=2Evanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c linux-2.6.18-rc6-m=
m1/drivers/scsi/aic7xxx_old.c
>> --- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-=
11 17:00:17.000000000 +0100
>> +++ linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-14 16:50=
:25.000000000 +0100
>> @@ -9194,7 +9194,7 @@
>>      for (i =3D 0; i < ARRAY_SIZE(aic_pdevs); i++)
>>      {
>>        pdev =3D NULL;
>> -      while ((pdev =3D pci_find_device(aic_pdevs[i].vendor_id,
>> +      while ((pdev =3D pci_get_device(aic_pdevs[i].vendor_id,
>>                                       aic_pdevs[i].device_id,
>=20
> NACK.  This doesn't help us forward at all.  In case you have
> the hardware please do a full conversion to the real pci probing API.
>=20
Ceterum censeo.

Why can't we just remove this driver? It pretty much obsoleted by now, =
or?

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
