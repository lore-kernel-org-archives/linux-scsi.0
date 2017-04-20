From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 16/23] blk-mq: remove the error argument to
 blk_mq_complete_request
Date: Thu, 20 Apr 2017 15:28:27 +0000
Message-ID: <1492702106.2642.4.camel@sandisk.com>
References: <20170420140316.6546-1-hch@lst.de>
         <20170420140316.6546-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170420140316.6546-17-hch@lst.de>
Content-Language: en-US
Content-ID: <128D21FA3D0AD545BCADCD3083154E03@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-04-20 at 16:03 +0200, Christoph Hellwig wrote:
> Now that all drivers that call blk_mq_complete_requests have a
> ->complete callback we can remove the direct call to blk_mq_end_request,
> as well as the error argument to blk_mq_complete_request.

Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>=
