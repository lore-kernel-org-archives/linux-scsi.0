From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: drop the T10 OSD code and its users
Date: Thu, 13 Apr 2017 22:27:38 -0400
Message-ID: <yq1inm7wwo5.fsf@oracle.com>
References: <20170412160109.10598-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170412160109.10598-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 12 Apr 2017 18:01:05 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: ooo@electrozaur.com, martin.petersen@oracle.com, trond.myklebust@primarydata.com, axboe@kernel.dk, osd-dev@open-osd.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and the
> other two users (osdblk and exofs) were simple example of it's usage.
>
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.

No particular objections from me.

-- 
Martin K. Petersen	Oracle Linux Engineering
