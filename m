From: Jens Axboe <axboe@suse.de>
Subject: Re: Redirecting request
Date: Mon, 28 Oct 2002 17:24:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028162433.GL2937@suse.de>
References: <3DBD3F8B.CDA9F96B@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DBD3F8B.CDA9F96B@patni.com>
List-Id: linux-scsi@vger.kernel.org
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Oct 28 2002, MShetty wrote:
> Hi,
> 
> In my make_request function (registered with blk_queue_make_request) I
> want to redirect the current request to "sd". To achieve this is it
> sufficient to write :
> bh->b_rdev = MKDEV(SCSI_DISK0_MAJOR, 0);
> 
> where bh is buffer_head

If b_rsector already points to the right offset off /dev/sda (not
partition), then yes.

-- 
Jens Axboe

