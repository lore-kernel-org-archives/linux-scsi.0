From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 13/18] scsi: remove scsi_cmd_dma_pool
Date: Fri, 27 Jan 2017 17:51:35 +0000
Message-ID: <1485539474.4267.15.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-14-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-14-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <2582A38F99400F4AAB433F310E08B5CE@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> There is no need for GFP_DMA allocations of the scsi_cmnd structures
> themselves, all that might be DMAed to or from is the actual payload,
> or the sense buffers.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
