From: Jens Axboe <axboe@suse.de>
Subject: Re: vmware and ide-scsi cdrom
Date: Fri, 19 Apr 2002 12:09:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020419100949.GJ2492@suse.de>
References: <20020419174521.4f5982eb.Corporal_Pisang@Counter-Strike.com.my>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020419174521.4f5982eb.Corporal_Pisang@Counter-Strike.com.my>
List-Id: linux-scsi@vger.kernel.org
To: Corporal Pisang <Corporal_Pisang@counter-strike.com.my>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 19 2002, Corporal Pisang wrote:
> Hi,
> 
> My cdrom will crash and gives a kernel oops whenever vmware try to
> access my cd for booting. Attached is the ksymoops output of the
> kernel oops.
> 
> After the kernel oops i would not be able to access the cdrom at all.
> 
> I dont know whether this list is appropriate for this problem or not.

Known problem, fixed in later ide updates. Coming to a kernel near you,
soon. Or look around for posted updates. I'll post an update later today
as well.

-- 
Jens Axboe

