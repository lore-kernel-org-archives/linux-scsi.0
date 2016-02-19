From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 07/23] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Fri, 19 Feb 2016 07:42:57 +0100
Message-ID: <56C6B971.1000505@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-8-git-send-email-hare@suse.de>
 <56C61E7B.9050509@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161414AbcBSGnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 01:43:00 -0500
In-Reply-To: <56C61E7B.9050509@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/18/2016 08:41 PM, Bart Van Assche wrote:
> On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
>>       if (optimize)
>> -        h->flags |=3D ALUA_OPTIMIZE_STPG;
>> +        pg->flags |=3D ALUA_OPTIMIZE_STPG;
>>       else
>> -        h->flags &=3D ~ALUA_OPTIMIZE_STPG;
>> +        pg->flags |=3D ~ALUA_OPTIMIZE_STPG;
>=20
> The above looks weird to me. Why has "&=3D" been changed into "|=3D" =
?
>=20
Bah. Of course.

Will be fixing it up.

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
