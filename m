From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Tue, 14 Jul 2015 16:32:00 +0200
Message-ID: <55A51D60.9010600@suse.de>
References: <20150713142439.GA14427@kernel.dk>	<20150714071358.GA31117@infradead.org> <55A4F0FD.6070305@suse.de>	<55A516E3.8040708@fb.com> <yq1mvyystwh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbGNOcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 10:32:02 -0400
In-Reply-To: <yq1mvyystwh.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 07/14/2015 04:20 PM, Martin K. Petersen wrote:
>>>>>> "Jens" =3D=3D Jens Axboe <axboe@fb.com> writes:
>=20
>>> Fully agreed. I would vote for making the host template read-only a=
nd
>>> modify all drivers to use the shost setting.
>=20
> Jens> Indeed, that would be a much saner choice. The settings in a
> Jens> (effectively already) read-only host template seems like somewh=
at
> Jens> of a relic.
>=20
> Agree 100%.
>=20
While we're at it: why is the 'cmd_pool' attached to the host
template? Do all hosts with the same driver share a common pool?
(I sincerely do hope not ...)

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
