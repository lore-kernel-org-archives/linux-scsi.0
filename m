From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SG_IO ioctl in block layer against lk 2.5.55
Date: Fri, 10 Jan 2003 14:06:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030110130622.GL841@suse.de>
References: <3E1EB08D.5060105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1EB08D.5060105@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Fri, Jan 10 2003, Douglas Gilbert wrote:
> The attachment modifies the SG_IO ioctl that is in
> the block layer to:
>   - convey the SCSI status value back via the sg_io_hdr
>     structure
>   - in the event of CHECK CONDITION, convey the sense
>     buffer back via the sg_io_hdr structure
>   - set "output" fields in sg_io_hdr structure to sane
>     values
>   - modify the errno behaviour to be more like the
>     SCSI generic driver's SG_IO ioctl
> 
> This patch was presented around lk 2.5.51 but fell between
> the cracks. The only modification is to take account of
> the changes to scsi/scsi_lib.c since then.

Doug,

Patch looks good to me, please feel free to send it to Linus.

-- 
Jens Axboe

