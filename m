From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 3/5] scsi: Move sense handling routines to scsi_common
Date: Fri, 10 Jul 2015 08:39:39 +0200
Message-ID: <559F68AB.8020401@suse.de>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com> <1436367534-15995-4-git-send-email-sagig@mellanox.com> <559D3C5C.4020903@suse.de> <559D4071.8010501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbbGJGjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2015 02:39:43 -0400
In-Reply-To: <559D4071.8010501@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 07/08/2015 05:23 PM, Sagi Grimberg wrote:
> On 7/8/2015 6:06 PM, Hannes Reinecke wrote:
>=20
>> We're adding extra fields here, so we need to make sure to not
>> overflow the buffer. You probably have to pass in the buffersize
>> to avoid an overflow ...
>> Yeah, I know, it's theoretical at the moment.
>> But there's nothing which prevents anyone to add other fields to it,
>> so this field might be the one causing the overflow.
>=20
> Since this patch is simply a movement of functions I don't think I
> should change any functionality here. Would it be acceptable to fix
> this in an incremental patch?
Sure.

So you can add a

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
