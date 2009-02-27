From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use list_splice for blk_abort_queue
Date: Fri, 27 Feb 2009 13:04:59 +0100
Message-ID: <49A7D6EB.5050905@suse.de>
References: <20090227113706.3005518C786@pentland.suse.de> <20090227114057.GC6602@kernel.dk> <49A7D32B.4020100@suse.de> <20090227115627.GD6602@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbZB0MFC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 07:05:02 -0500
In-Reply-To: <20090227115627.GD6602@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Fri, Feb 27 2009, Hannes Reinecke wrote:
>> Hi Jens,
>>
>> Jens Axboe wrote:
[ .. ]
>>> Hannes, this fix has been in mainline for about 10 days.
>>>
>> Ah, sorry. Missed that one.
>> I'm just about to catch up with unread mails, and you said something
>> about 'the original author should resend the patch'.
>> Which I did.
>=20
> Yep, I did say that. But after a few days I figured you were probably
> away or something, so I hacked up a changelog myself and put it in
> there. It was already tested good and it makes sense.
>=20
Yes, indeed 'something'. Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
