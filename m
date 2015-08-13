From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Fixup fixed sense generation
Date: Thu, 13 Aug 2015 09:31:41 +0200
Message-ID: <55CC47DD.5070806@suse.de>
References: <1438347903-106697-1-git-send-email-hare@suse.de> <55C99AF6.5080601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbbHMHbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Aug 2015 03:31:43 -0400
In-Reply-To: <55C99AF6.5080601@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/11/2015 08:49 AM, Sagi Grimberg wrote:
>=20
>> -        put_unaligned_be64(info, &buf[3]);
>> +        /*
>> +         * Fixed format sense reserves only 32 bits for the
>> +         * 'information' field
>> +         */
>> +        put_unaligned_be32((u32)info, &buf[3]);
>>       }
>>   }
>>   EXPORT_SYMBOL(scsi_set_sense_information);
>>
>=20
> Hannes,
>=20
> This bit is handled in "scsi: Fix sense information setting in fixed
> sized format"
> see http://permalink.gmane.org/gmane.linux.scsi/103115
>=20
> Can you make it incremental to this patch?
>=20
Sure, I will.

> James, I don't see it on the scsi tree, can you pick it up?
>=20
James, please. The patch already has the required Reviewed-by tags.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
