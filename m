From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Controlling PATA access speeds
Date: Thu, 1 Jun 2006 14:52:44 -0400
Message-ID: <20060601185244.GH5869@havoc.gtf.org>
References: <BAY113-F9629AB1FA5713C03D4F42DF900@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:11986 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S965101AbWFASwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 14:52:46 -0400
Content-Disposition: inline
In-Reply-To: <BAY113-F9629AB1FA5713C03D4F42DF900@phx.gbl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Jun 01, 2006 at 12:25:45PM -0500, John Treubig wrote:
> We are currently using Promise Ultra133 TX2 (PDC20269 chip; pata_pdc2027x 
> driver, kernel version 2.6.15) to test and access PATA drives.   If my 
> understanding is correct, during boot, a drive is queryied to determine 
> it's maximum access speed and the driver sets the access speed to be no 
> higher than the drive can handle.  This is not speed testing the drive, but 
> just the drive firmware reporting it's maximum designed transfer rate.  Due 
> to design constraints of the cabling to the drives, we need to force the 
> access speed lower than what the Drive reponds.  Is there a mechanism to 
> tell the driver/LibATA to set the access speed to go no higher than a value 
> I supply? This can be a static setting that is set at boot, as it does not 
>  need to be a dynamic setting.

The driver includes code to do cable detect.  Is this insufficient for
some reason?

	Jeff



