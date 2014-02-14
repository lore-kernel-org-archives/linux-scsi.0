From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Fri, 14 Feb 2014 12:38:28 +0100
Message-ID: <52FE0034.5060007@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de> <52FDFD85.9050106@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaBNLi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 06:38:29 -0500
In-Reply-To: <52FDFD85.9050106@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 12:27 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> -	memset(h->buff, 0, stpg_len);
>> -	h->buff[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> -	h->buff[6] =3D (h->group_id >> 8) & 0xff;
>> -	h->buff[7] =3D h->group_id & 0xff;
>> +	memset(stpg_data, 0, stpg_len);
>> +	stpg_data[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> +	stpg_data[6] =3D (group_id >> 8) & 0xff;
>> +	stpg_data[7] =3D group_id & 0xff;
>=20
> Any reason why put_unaligned_be16() is not used here ?
>=20
No specific one. Will be fixing it up in the next round.

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
