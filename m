From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 11/23] block_dev: use blkdev_issue_zerout for hole
 punches
Date: Tue, 28 Mar 2017 16:50:47 +0000
Message-ID: <1490719834.2573.9.camel@sandisk.com>
References: <20170323143341.31549-1-hch@lst.de>
         <20170323143341.31549-12-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-12-hch@lst.de>
Content-Language: en-US
Content-ID: <870212604B83404C82828EFFF2BD9132@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-03-23 at 10:33 -0400, Christoph Hellwig wrote:
> This gets us support for non-discard efficient write of zeroes (e.g. NVMe=
)
> and preparse for removing the discard_zeroes_data flag.

Hello Christoph,

"preparse" probably should have been "prepare"?

Thanks,

Bart.=
