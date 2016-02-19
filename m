From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 21/23] scsi_dh_alua: use common definitions for ALUA
 state
Date: Fri, 19 Feb 2016 07:50:43 +0100
Message-ID: <56C6BB43.4040003@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-22-git-send-email-hare@suse.de>
 <56C640F9.4060402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423088AbcBSGup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 01:50:45 -0500
In-Reply-To: <56C640F9.4060402@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/18/2016 11:08 PM, Bart Van Assche wrote:
> On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>> @@ -180,7 +172,7 @@ static int submit_stpg(struct scsi_device
>> *sdev, int group_id,
>>
>>       /* Prepare the data buffer */
>>       memset(stpg_data, 0, stpg_len);
>> -    stpg_data[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> +    stpg_data[4] =3D SCSI_ACCESS_STATE_OPTIMAL & 0x0f;
>>       put_unaligned_be16(group_id, &stpg_data[6]);
>>
>=20
> In the previous patch a symbolic name for the ALUA state mask has
> been introduced (SCSI_ACCESS_STATE_MASK). Hence please either leave
> out "& 0x0f" from the above code or use that constant.
>=20
Ok.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
