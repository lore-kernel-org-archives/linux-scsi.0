From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 30 Aug 2010 12:04:56 +0200
Message-ID: <4C7B8248.5070602@suse.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <20100823140823.GA23490@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100823140823.GA23490@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "tytso@mit.edu" <tytso@mit.edu>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 04:01:15PM +0200, Jens Axboe wrote:
>> The problem purely exists on arrays that report write back cache ena=
bled
>> AND don't implement SYNC_CACHE as a noop. Do any of them exist, or a=
re
>> they purely urban legend?
>=20
> I haven't seen it.  I don't care particularly about this case, but on=
ce
> it a while people want to disable flushing for testing or because the=
y
> really don't care.
>=20
aacraid for one falls into this category.
SYNC_CACHE is no-oped in the driver. Otherwise you get a _HUGE_
performance loss.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
