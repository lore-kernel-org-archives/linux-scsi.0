From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/16] scsi_dh_alua: Pass buffer as function argument
Date: Fri, 14 Feb 2014 12:36:25 +0100
Message-ID: <52FDFFB9.7070604@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-4-git-send-email-hare@suse.de> <52FDFC65.2040906@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaBNLg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 06:36:26 -0500
In-Reply-To: <52FDFC65.2040906@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 12:22 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> -	rq->cmd[6] =3D (h->bufflen >> 24) & 0xff;
>> -	rq->cmd[7] =3D (h->bufflen >> 16) & 0xff;
>> -	rq->cmd[8] =3D (h->bufflen >>  8) & 0xff;
>> -	rq->cmd[9] =3D h->bufflen & 0xff;
>> +	rq->cmd[6] =3D (bufflen >> 24) & 0xff;
>> +	rq->cmd[7] =3D (bufflen >> 16) & 0xff;
>> +	rq->cmd[8] =3D (bufflen >>  8) & 0xff;
>> +	rq->cmd[9] =3D bufflen & 0xff;
>=20
> Since you are changing this code, please use put_unaligned_be32() for
> storing bufflen in the CDB.
>=20
Ok. Will be fixing it up in the next round.

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
