From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] merge sd.h into sd.c and some cleanup
Date: Sun, 27 Oct 2002 22:22:03 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBBCC5B.50708@torque.net>
References: <20021026031850.A5491@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Now that only sd.c includes sd.h it can be safely merged into it.
> Also get rid of typedef abuse in sd.c
> 
> 
> --- 1.76/drivers/scsi/sd.c	Thu Oct 24 21:27:14 2002
> +++ edited/drivers/scsi/sd.c	Sat Oct 26 01:20:04 2002
> @@ -18,7 +17,7 @@
>   *	 - Alex Davis <letmein@erols.com> Fix problem where partition info
>   *	   not being read in sd_open. Fix problem where removable media 
>   *	   could be ejected after sd_open.
> - *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5 series
> + *	 - Douglas Gilbert <dgilbert@interlog.com> cleanup for lk 2.5.x
>   *
<snip>

Christoph,
The patch looks good. However ....
The header file "sd.h" is included in quite a few lower level
drivers in lk 2.5.44 (at least 55) and perhaps in a couple of
other subsystems. The reason it is included is for the
"biosparam" call in the API of lower level drivers. Whether
it is still used or useful, I'm not sure. [It does seem
quite unreasonable that lower level drivers need to include
an upper level header.]

You can drop my credit line (shown above) from sd.c . Perhaps
James could make a "credits" file for everyone who has helped
in the 2.5 scsi rework.

Doug Gilbert

