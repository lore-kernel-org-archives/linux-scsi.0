From: Florian Westphal <fw@strlen.de>
Subject: Re: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Date: Mon, 29 Apr 2013 18:29:07 +0200
Message-ID: <20130429162907.GH32324@breakpoint.cc>
References: <20130429152639.GG32324@breakpoint.cc>
 <yq1obcxpb76.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1obcxpb76.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Florian Westphal <fw@strlen.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, adam radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen <martin.petersen@oracle.com> wrote:
> Florian> After update to 3.8 dmesg is spammed with: kernel: [
> Florian> 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41 kernel: [
> Florian> 280.272107] sd 8:0:0:0: [sda] Unhandled error code kernel: 
> 
> Interesting. It looks like the 3ware handles this at the driver level
> instead of passing the command through to the disk and letting it
> fail. That in turn means that the logic we have in place to disable WS
> when the disk does not support it does not get triggered.
> 
> The driver should really fill out the sense buffer in that case.
> 
> Could you please test the patch below?

Sure, I'll report back tomorrow.

Thanks for the quick response,
Florian
