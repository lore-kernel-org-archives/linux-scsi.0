From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Wed, 16 Mar 2016 09:12:33 +0100
Message-ID: <56E91571.6000900@suse.com>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
 <yq137rshbrr.fsf@sermon.lab.mkp.net> <56E7B9AA.3020302@suse.de>
 <20160315074232.GA10944@lst.de> <56E84419.3040109@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966139AbcCPIMk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2016 04:12:40 -0400
In-Reply-To: <56E84419.3040109@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>

On 03/15/2016 06:19 PM, Douglas Gilbert wrote:
> On 16-03-15 08:42 AM, Christoph Hellwig wrote:
>> On Tue, Mar 15, 2016 at 08:28:42AM +0100, Hannes Reinecke wrote:
>>> But it feels even sillier having to whitelist every
>>> standards-conformant device here; I certainly was when I figured
>>> that EMC Clariion won't work properly without this patch.
>>>
>>> And the idea was to mark off _misbehaving_ drives, not the other wa=
y
>>> round.
>>
>> It's the idea, but it has to prove workable as well in the end.
>>
>> That being said I'd prefer to allow Hannes patch in and see what
>> the fallout is.
>=20
> I don't have many drafts archived for SPC-2 but the two that I do hav=
e:
>    spc2r18.pdf [20000521]
>    spc2r20.pdf [20010718]
>=20
> indicate that those two VPD pages were made mandatory right at the
> end of the draft cycle for SPC-2. spc2r20.pdf was the last draft
> prior to the standard and it does show them as mandatory in table 185
> on page 218. The corresponding table in spc2r18.pdf does not have
> a column indicating whether the listed VPD pages are mandatory or
> not (or words that I can find in the description of VPD pages 0x0
> and 0x83 to suggest they are mandatory).
>=20
The point here is not so much whether the pages are mandatory, but
whether access to VPD pages crashes the device.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
