From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/10] scsi_dh: move 'dh_state' sysfs attribute to generic
 code
Date: Thu, 09 Jul 2015 10:44:46 +0200
Message-ID: <559E347E.8060402@suse.de>
References: <1436346425-96635-1-git-send-email-hare@suse.de> <20150709082424.GB1419@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbbGIIos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 04:44:48 -0400
In-Reply-To: <20150709082424.GB1419@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

On 07/09/2015 10:24 AM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 11:07:05AM +0200, Hannes Reinecke wrote:
>> As scsi_dh.c is now always compiled in we should be moving
>> the 'dh_state' attribute to the generic code.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> Looks fine, but a few coding style nitpicks:
>=20
>> +	if (!sdev->handler) {
>> +		/*
>> +		 * Attach to a device handler
>> +		 */
>> +		err =3D scsi_dh_attach(sdev->request_queue, buf);
>> +	} else {
>> +		if (!strncmp(buf, "detach", 6)) {
>=20
> Switch to en else if here.  Also may=E3=81=B9e move the activate case=
 up as it's
> relevant while detach is dead now.
>=20
Okay.

>> +	return err<0?err:count;
>=20
> Please add the missing spaces here.
>=20
Will be doing so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
