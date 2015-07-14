From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Tue, 14 Jul 2015 16:14:58 +0200
Message-ID: <55A51962.5040803@suse.de>
References: <20150713142439.GA14427@kernel.dk> <20150714071358.GA31117@infradead.org> <55A4F0FD.6070305@suse.de> <55A516E3.8040708@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbbGNOPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 10:15:00 -0400
In-Reply-To: <55A516E3.8040708@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 07/14/2015 04:04 PM, Jens Axboe wrote:
> On 07/14/2015 05:22 AM, Hannes Reinecke wrote:
>> On 07/14/2015 09:13 AM, Christoph Hellwig wrote:
>>> Looks good:
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> I wonder if we should start to gradually phase out these tuables
>>> in the
>>> host template.  It's not really more complicated to set them
>>> directly
>>> in the host anyway.
>>
>> Fully agreed. I would vote for making the host template read-only
>> and modify all drivers to use the shost setting.
>=20
> Indeed, that would be a much saner choice. The settings in a
> (effectively already) read-only host template seems like somewhat of
> a relic.
>=20
Plus some drivers have the habit of modifying the template based on
the settings _for this particular_ device, which leads to
interesting results if you have several devices with _different_
settings ...

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
