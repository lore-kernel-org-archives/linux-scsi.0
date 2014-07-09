From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] Add defines for new FC port speeds.
Date: Wed, 09 Jul 2014 12:47:44 +0200
Message-ID: <53BD1DD0.4000105@suse.de>
References: <814CB474615D9040840B5BA11313B6CB3D85763C@CMEXMB1.ad.emulex.com> <20140625105738.GA19049@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaGIKrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 06:47:46 -0400
In-Reply-To: <20140625105738.GA19049@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dick Kennedy <Dick.Kennedy@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/25/2014 12:57 PM, Christoph Hellwig wrote:
> Can I get another review for this one?
>
> On Fri, Jun 13, 2014 at 04:40:36PM +0000, Dick Kennedy wrote:
>> These speeds are to support the next generation of FCoE port speeds.
>> Signed-off-by: rkennedy@emulex.com
>> ---
>>   drivers/scsi/scsi_transport_fc.c |    4 ++++
>>   include/scsi/scsi_transport_fc.h |    4 ++++
>>   2 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tr=
ansport_fc.c
>> index f80908f..454cc28 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -262,6 +262,10 @@ static const struct {
>>          { FC_PORTSPEED_8GBIT,           "8 Gbit" },
>>          { FC_PORTSPEED_16GBIT,          "16 Gbit" },
>>          { FC_PORTSPEED_32GBIT,          "32 Gbit" },
>> +       { FC_PORTSPEED_20GBIT,          "20 Gbit" },
>> +       { FC_PORTSPEED_40GBIT,          "40 Gbit" },
>> +       { FC_PORTSPEED_50GBIT,          "50 Gbit" },
>> +       { FC_PORTSPEED_100GBIT,         "100 Gbit" },
>>          { FC_PORTSPEED_NOT_NEGOTIATED,  "Not Negotiated" },
>>   };
>>   fc_bitfield_name_search(port_speed, fc_port_speed_names)
>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_tr=
ansport_fc.h
>> index 8c79980..007a0bc 100644
>> --- a/include/scsi/scsi_transport_fc.h
>> +++ b/include/scsi/scsi_transport_fc.h
>> @@ -131,6 +131,10 @@ enum fc_vport_state {
>>   #define FC_PORTSPEED_8GBIT             0x10
>>   #define FC_PORTSPEED_16GBIT            0x20
>>   #define FC_PORTSPEED_32GBIT            0x40
>> +#define FC_PORTSPEED_20GBIT            0x80
>> +#define FC_PORTSPEED_40GBIT            0x100
>> +#define FC_PORTSPEED_50GBIT            0x200
>> +#define FC_PORTSPEED_100GBIT           0x400
>>   #define FC_PORTSPEED_NOT_NEGOTIATED    (1 << 15) /* Speed not esta=
blished */
>>
>>   /*
>> --
>> 1.6.6

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
