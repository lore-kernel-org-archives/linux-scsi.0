From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 04/18] block: simplify blk_init_allocated_queue
Date: Thu, 26 Jan 2017 23:27:22 +0000
Message-ID: <1485473221.2540.23.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
         <1485365126-23210-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-5-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <0067EA4077B59542A7F0915625239AD7@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> Return an errno value instead of the passed in queue so that the callers
> don't have to keep track of two queues, and move the assignment of the
> request_fn and lock to the caller as passing them as argument doesn't
> simplify anything.  While we're at it also remove two pointless NULL
> assignments, given that the request structure is zeroed on allocation.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
