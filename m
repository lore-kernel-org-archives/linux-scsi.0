From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/10] scsi: add 'am53c974' driver
Date: Fri, 21 Nov 2014 11:34:28 +0100
Message-ID: <546F1534.5000104@suse.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-7-git-send-email-hare@suse.de> <546F107A.3020504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbaKUKe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:34:29 -0500
In-Reply-To: <546F107A.3020504@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 11/21/2014 11:14 AM, Paolo Bonzini wrote:
>=20
>=20
> On 21/11/2014 10:27, Hannes Reinecke wrote:
>> This patch adds a new implementation for the Tekram DC-390T /
>> AMD AM53c974 SCSI controller, based on the generic
>> esp_scsi infrastructure.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/Kconfig    |  18 ++
>>  drivers/scsi/Makefile   |   1 +
>>  drivers/scsi/am53c974.c | 523 +++++++++++++++++++++++++++++++++++++=
+++++++++++
>>  3 files changed, 542 insertions(+)
>>  create mode 100644 drivers/scsi/am53c974.c
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 21bc674..497e7d5 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1357,6 +1357,24 @@ config SCSI_DC390T
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called tmscsim.
>> =20
>> +config SCSI_AM53C974
>> +	tristate "Tekram DC390(T) and Am53/79C974 SCSI support (new driver=
)"
>> +	depends on PCI && SCSI
>=20
> Perhaps make it a choice with SCSI_DC390, since they match on the sam=
e
> PCI vendor/device IDs?
>=20
Cf my response to Christoph. The idea was to have another patch
removing tmscsim altogether :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
