From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 12/18] scsi: respect unchecked_isa_dma for blk-mq
Date: Fri, 27 Jan 2017 17:45:14 +0000
Message-ID: <1485539094.4267.14.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-13-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <9B1032A810FA4F4FA09AE00071699E04@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> Currently blk-mq always allocates the sense buffer using normal GFP_KERNE=
L
> allocation.  Refactor the cmd pool code to split the cmd and sense alloca=
tion
> and share the code to allocate the sense buffers as well as the sense buf=
fer
> slab caches between the legacy and blk-mq path.
>=20
> Note that this switches to lazy allocation of the sense slab caches - the
> slab caches (not the actual allocations) won't be destroy until the scsi
> module is unloaded instead of keeping track of hosts using them.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
