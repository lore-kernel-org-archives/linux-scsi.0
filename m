From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix rescan warning
Date: Tue, 18 Mar 2003 09:13:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030318091345.A3361@lst.de>
References: <20030317165301.B29420@lst.de> <3E7673F2.2000409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7673F2.2000409@torque.net>; from dougg@torque.net on Tue, Mar 18, 2003 at 11:18:42AM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Mar 18, 2003 at 11:18:42AM +1000, Douglas Gilbert wrote:
> Christoph,
> How does this work from a users point of view?
> Something like:
>    # cd /sys/bus/scsi/devices/2:0:0:0
>    # echo "anything_I_like" > rescan

I think that's how it's supposed to work - it's not my code though
and I haven't tested it.

> A sysfs store() is meant to return the number of
> bytes consumed. In that case shouldn't the last
> active line of the patch be "return count;".

I think you're right.

