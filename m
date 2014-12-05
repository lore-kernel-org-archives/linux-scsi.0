From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN scanning
Date: Fri, 05 Dec 2014 19:34:05 +0100
Message-ID: <5481FA9D.6040305@suse.de>
References: <1417711162-102950-1-git-send-email-hare@suse.de> <20141205004315.00001523@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLESeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 13:34:08 -0500
In-Reply-To: <20141205004315.00001523@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>

On 12/05/2014 12:43 AM, Sebastian Herbszt wrote:
> Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo=
=2Ec
>> index 49014a1..4f446e3 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -166,6 +166,7 @@ static struct {
>>  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
>>  	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
>>  	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>> +	{"FUJITSU", "ETERNUS_DX", "*", BLIST_TEST_LUN0 },
>>  	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIR=
Y_36},
>>  	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQU=
IRY_36},
>>  	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQU=
IRY_36},
>=20
> Does this apply to all ETERNUS DX models and generations?
>=20
So I've been given to understand. Matthias Roessler will have details.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
