From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of block-integrity
Date: Fri, 03 Jan 2014 16:01:47 +0100
Message-ID: <52C6D0DB.1050906@suse.de>
References: <20131222192128.GA28532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131222192128.GA28532@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/22/2013 08:21 PM, Christoph Hellwig wrote:
> We have the block integrity code to support DIF/DIX in the the tree f=
or
> about 5 and a half years, and we still don't have a single consumer o=
f
> it.  By normal kernel rules it should never have been merged, or at
> least the bitrot long removed.
>
> Given that we'll have a lot of work to do in this area with block
> multiqueue I think it's time to either kill it off for good or make s=
ure
> we can actually use and test it.

Which would make an ideal topic for LSF, wouldn't it?

Personally, I doubt it's a good idea to kill it off, but
a proper (userland) API for it has been a long time missing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
