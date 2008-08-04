From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] cciss: return -EFAULT if copy_from_user() fails
Date: Mon, 4 Aug 2008 10:58:14 +0200
Message-ID: <20080804085814.GZ20055@kernel.dk>
References: <200807311135.48889.knikanth@suse.de> <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754414AbYHDI63@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, ISS StorageDev <iss_storagedev@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 31 2008, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: Nikanth Karthikesan [mailto:knikanth@suse.de]
> > Sent: Thursday, July 31, 2008 1:06 AM
> > To: Miller, Mike (OS Dev)
> > Cc: ISS StorageDev; Jens Axboe
> > Subject: [PATCH] cciss: return -EFAULT if copy_from_user() fails
> >
> > Return -EFAULT instead of -ENOMEM if copy_from_user() fails.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> Acked-by: Mike Miller <mike.miller@hp.com>

Applied

-- 
Jens Axboe
