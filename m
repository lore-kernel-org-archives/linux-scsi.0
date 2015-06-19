From: Hannes Reinecke <hare@suse.de>
Subject: Re: Merging se_dev_entry and se_lun?
Date: Fri, 19 Jun 2015 15:21:27 +0200
Message-ID: <55841757.1090904@suse.de>
References: <5583B957.20200@suse.de> <20150619065624.GA3601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150619065624.GA3601@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 06/19/2015 08:56 AM, Christoph Hellwig wrote:
> On Fri, Jun 19, 2015 at 08:40:23AM +0200, Hannes Reinecke wrote:
>> Having a list here implies that 'se_lun' can have _several_
>> se_dev_entry structure attached to it, which I found rather curious.
>>
>> Can you give me an example where this might be the case?
>> Or can we replace the list with a simple pointer or even merge both?
>=20
> Each initiator has it's own dev entry.
>=20
But isn't 'se_lun' per initiator, too?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
