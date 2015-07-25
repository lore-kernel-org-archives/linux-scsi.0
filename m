From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/20] scsi_dh_alua: parse target device id
Date: Sat, 25 Jul 2015 17:53:21 +0200
Message-ID: <55B3B0F1.9040503@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-15-git-send-email-hare@suse.de> <20150724150740.GB29434@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbbGYPxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:53:24 -0400
In-Reply-To: <20150724150740.GB29434@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 05:07 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 11:06:12AM +0200, Hannes Reinecke wrote:
>> Parse VPD descriptor to figure out the device identification.
>> As devices might implement several descriptors the order
>> of preference is:
>> - NAA IEE Registered Extended
>> - EUI-64 based 16-byte
>> - EUI-64 based 12-byte
>> - NAA IEEE Registered
>> - NAA IEEE Extended
>> A SCSI name string descriptor is preferred to all of them
>> if the identification is longer than 16 bytes.
>=20
> Can you move this to scsi_mod.ko?  I'll need the same code for the NF=
S
> SCSI layout driver soon.
>=20
Ok, will be doing so.

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
