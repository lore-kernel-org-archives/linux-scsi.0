From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: scsi in 2.5.48
Date: Tue, 19 Nov 2002 05:06:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119130601.GM23425@holomorphy.com>
References: <3DD8AF65.BF2EF851@digeo.com> <3DD8B6B9.E9EAD230@digeo.com> <20021118135614.GA834@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021118135614.GA834@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Morton <akpm@digeo.com>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Andrew Morton wrote:
>>> Appears to be DOA.  Just a simple mke2fs hangs in get_request_wait().

On Mon, Nov 18 2002, Andrew Morton wrote:
>> This makes it work again.

On Mon, Nov 18, 2002 at 02:56:14PM +0100, Jens Axboe wrote:
> Right fix would be something ala:

This solves my free_initmem() deadlock, which for some reason I assumed
to be a problem of a lower-level nature.


Bill
