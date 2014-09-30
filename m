From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_host: fix comment
Date: Tue, 30 Sep 2014 13:15:31 +0200
Message-ID: <542A90D3.1050602@suse.de>
References: <20140920133755.0000496a@localhost> <542A9054.1000306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaI3LPd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:15:33 -0400
In-Reply-To: <542A9054.1000306@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

On 09/30/2014 01:13 PM, Bart Van Assche wrote:
> On 09/20/14 13:37, Sebastian Herbszt wrote:
>> Commit 1abf635 (scsi: use 64-bit value for 'max_luns') changed the
>> order
>> of Scsi_Host members. Update the comment to reflect this.
>>
>> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
>>
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index ba20347..d4e0509 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -603,13 +603,13 @@ struct Scsi_Host {
>>       unsigned long last_reset;
>>
>>
>>       /*
>>        * These three parameters can be used to allow for wide scsi,
>>        * and for host adapters that support multiple busses
>> -     * The first two should be set to 1 more than the actual max id
>> +     * The last two should be set to 1 more than the actual max id
>>        * or lun (e.g. 8 for SCSI parallel systems).
>>        */
>>       unsigned int max_channel;
>>       unsigned int max_id;
>>       u64 max_lun;
>=20
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
