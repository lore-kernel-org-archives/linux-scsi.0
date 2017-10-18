From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v10 00/10] block, scsi, md: Improve suspend and resume
Date: Wed, 18 Oct 2017 07:02:24 +0200
Message-ID: <11010777.WJQNYl18e6@natalenko.name>
References: <20171017232630.4264-1-bart.vanassche@wdc.com> <9c33db06-39e7-fd61-f146-4ae6df4302b5@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9c33db06-39e7-fd61-f146-4ae6df4302b5@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

I've indeed tested some previous versions of this patchset, but still use=20
Ming's solution.

Can it be clarified which one (Bart's or Ming's) is a correct approach?

On st=C5=99eda 18. =C5=99=C3=ADjna 2017 1:28:14 CEST Jens Axboe wrote:
> On 10/17/2017 05:26 PM, Bart Van Assche wrote:
> > Hello Jens,
> >=20
> > It is known that during the resume following a hibernate, especially wh=
en
> > using an md RAID1 array created on top of SCSI devices, sometimes the
> > system hangs instead of coming up properly. This patch series fixes that
> > problem. These patches have been tested on top of the block layer for-n=
ext
> > branch. Please consider these changes for kernel v4.15.
>=20
> The folks that had trouble with this issue, have they tested the
> patchset? I'd like to get a solution queued up for this sooner rather
> than later, but I'd greatly prefer if we had some folks that have
> tested and verified it.
