From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] turn scsi_allocate_device into readable code
Date: Thu, 21 Nov 2002 10:36:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121153619.GB14063@redhat.com>
References: <20021121161647.B14037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021121161647.B14037@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Nov 21, 2002 at 04:16:47PM +0100, Christoph Hellwig wrote:
> 
> --- 1.23/drivers/scsi/cpqfcTSinit.c	Fri Oct 25 03:13:39 2002
> +++ edited/drivers/scsi/cpqfcTSinit.c	Thu Nov 21 15:51:32 2002
> @@ -1604,7 +1604,7 @@
>    scsi_cdb[0] = RELEASE;
>  
>    // allocate with wait = true, interruptible = false 
> -  SCpnt = scsi_allocate_device(ScsiDev, 1, 0);
> +  SCpnt = scsi_allocate_device(ScsiDev, 1);
>    {

Dammit all to hell man!  If you keep making patches that keep conflicting 
with my changes we're going to be merging forever!  :-)

James, have you dropped Christoph's latest stuff into a tree yet?  If so, 
I'll pull it and do my merging there...if not then I'll start grabbing 
patches from an archive (I didn't expect so many of them to overlap so 
closely today).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
