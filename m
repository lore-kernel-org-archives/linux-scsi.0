From: "hch@lst.de" <hch@lst.de>
Subject: Re: block: add a error_count field to struct request
Date: Wed, 19 Apr 2017 08:15:19 +0200
Message-ID: <20170419061519.GC6257@lst.de>
References: <20170418155229.5977-1-hch@bombadil.infradead.org> <20170418155229.5977-18-hch@bombadil.infradead.org> <1492556229.2689.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492556229.2689.22.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 18, 2017 at 10:57:11PM +0000, Bart Van Assche wrote:
> Both blk-mq and the traditional block layer support a .cmd_size field to
> make the block layer core allocate driver-specific data at the end of struct
> request. Could that mechanism have been used for the error_count field?

It could, and that's what I did for the modern drivers.  It would have
been a bit of a pain for these old floppy drivers, though.
