From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH, resend] IB/srp: Add 64-bit LUN support
Date: Wed, 4 Mar 2015 16:54:08 +0100
Message-ID: <54F72AA0.1070903@sandisk.com>
References: <54F6D7ED.3080606@sandisk.com>
 <1425474982.3069.21.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:44696
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932807AbbCDPyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2015 10:54:16 -0500
In-Reply-To: <1425474982.3069.21.camel@opteya.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 03/04/15 14:16, Yann Droneaud wrote:
> Le mercredi 04 mars 2015 =C3=A0 11:01 +0100, Bart Van Assche a =C3=A9=
crit :
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniban=
d/ulp/srp/ib_srp.c
>> index a0e24a8..e427454 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -3146,7 +3146,7 @@ static ssize_t srp_create_target(struct device=
 *dev,
>>  	target_host->transportt  =3D ib_srp_transport_template;
>>  	target_host->max_channel =3D 0;
>>  	target_host->max_id      =3D 1;
>> -	target_host->max_lun     =3D SRP_MAX_LUN;
>> +	target_host->max_lun     =3D -1LL;
>=20
> I guess you can remove SRP_MAX_LUN from
> drivers/infiniband/ulp/srp/ib_srp.h too.

Hello Yann,

That sounds like a good idea to me. I will update this patch accordingl=
y.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
