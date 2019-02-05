From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V4
Date: Mon, 04 Feb 2019 22:47:59 -0500
Message-ID: <yq1wome28wg.fsf@oracle.com>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 1 Feb 2019 08:55:49 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and we
> removed it 1.5 years ago.  Exofs is just a simple example without real
> life users.
>
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, and does not even work properly currently,
> so I think it's finally time to drop it.

Applied to 5.1/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
