From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 18:54:47 +0200
Message-ID: <4BEC2ED7.9080001@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org> <1273768687.4353.235.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273768687.4353.235.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

Hello,

On 05/13/2010 06:38 PM, James Bottomley wrote:
> Instead of making this a block sysfs attribute, since HPA is SATA only,
> why not make it a libata attribute for the disk?
> 
> That way on unlock, you can unlock the HPA and then trigger a partition
> rescan of the block device (BLKRRPART) ... this is an ioctl, so you need
> user context, but you have it if you do it from the sysfs write routine.
> This looks to be a lot simpler than threading it up through SCSI and
> block.

This doesn't have anything to do with sysfs.  It's called from block
partition scan code when it detects a partition extends beyond the end
of the device.  No user intervention at all and the mechanism has been
there for quite some years and possibly predates sysfs.  Am I being
really slow or are you looking at something else?

Thanks.

-- 
tejun
