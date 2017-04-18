From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: RFC: drop the T10 OSD code and its users
Date: Tue, 18 Apr 2017 19:24:06 +0300
Message-ID: <13c543db-dd38-1825-a58d-b4dff99e5f3c@electrozaur.com>
References: <20170412160109.10598-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170412160109.10598-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, trond.myklebust@primarydata.com, axboe@kernel.dk
Cc: osd-dev@open-osd.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/12/2017 07:01 PM, Christoph Hellwig wrote:

Hi Sir Christoph

> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and the
> other two users (osdblk and exofs) were simple example of it's usage.
> 

I understand why osdblk might be a pain, and was broken from day one, and
should by all means go away ASAP.

But exofs should not be bothering anyone, and as far as I know does
not use any special API's except the osd_uld code of course.

> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.
> 

Please tell me what are those changes you are talking about? I might be
able to help in conversion. I guess you mean osd_uld and the Upper SCSI API.
Just point me at a tree where osd_uld is broken, and perhaps with a little
guidance from you I can do a satisfactory conversion.

Is true that no new code went in for a long while, but I still from time
to time run a setup and test that the all stack, like iscsi-bidi and so on still
works.

That said, yes only a stand alone exofs was tested for a long time, a full
pnfs setup is missing any supporting server. So Yes I admit that pnfs-obj is
getting very rotten. And is most probably broken, on the pnfs side of things.
[Which I admit makes my little plea kind of mute ;-) ]

Every once in a while I get emails from Students basing all kind of interesting
experiments on top of the exofs and object base storage. So for the sake of academics
and for the sake of a true bidi-stack testing, might we want to evaluate what is the
up coming cost, and what is a minimum set we are willing to keep?

Please advise?

thanks
Boaz

> These patches are against Jens' block for-next tree as that already
> has various modifications of the SCSI code.
> 
