From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 00/36] asynchronous ALUA device handler
Date: Tue, 13 Oct 2015 17:13:01 +0200
Message-ID: <561D1F7D.7070803@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <560AD88B.9050902@sandisk.com> <560BE1DC.9060600@suse.de> <560C5509.6050206@sandisk.com> <561CD294.3080905@suse.de> <561D1E3E.5030201@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbbJMPND (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 11:13:03 -0400
In-Reply-To: <561D1E3E.5030201@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/13/2015 05:07 PM, Bart Van Assche wrote:
> On 10/13/2015 02:44 AM, Hannes Reinecke wrote:
>> I have rebased my patches to 4.3.0-rc5 and didn't see any lockups;
>> tested with hpsa and lpfc, both mq enabled and disabled.
>>
>> Can you check if it's specific to ib_srp? Is there a way to simulate
>> an ib_srp setup?
>=20
> Hello Hannes,
>=20
> This infinite loop was due to the scsi_dh_alua handler not being
> loaded during my test (as mentioned in
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg42645.html=
).
>=20
So it works with that patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
