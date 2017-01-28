From: "hch@lst.de" <hch@lst.de>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Sat, 28 Jan 2017 09:29:00 +0100
Message-ID: <20170128082900.GE4728@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de> <1485552454.4267.29.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485552454.4267.29.camel@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27, 2017 at 09:27:53PM +0000, Bart Van Assche wrote:
> Have you considered to convert all block drivers to the new
> approach and to get rid of request.special? If so, do you already
> have plans to start working on this? I'm namely wondering wheter I
> should start working on this myself.

Hi Bart,

I'd love to have all drivers move of using .special (and thus reducing
request size further).  I think the general way to do that is to convert
them to blk-mq and not using the legacy cmd_size field.
