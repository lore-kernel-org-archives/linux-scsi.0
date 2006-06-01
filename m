From: "John Treubig" <jtreubig@hotmail.com>
Subject: Re: Controlling PATA access speeds
Date: Thu, 01 Jun 2006 15:35:23 -0500
Message-ID: <BAY113-F2199B8BEE31723E17D24CCDF900@phx.gbl>
References: <20060601185244.GH5869@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay113-f21.bay113.hotmail.com ([65.54.168.31]:5615 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S1030271AbWFAUf0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 16:35:26 -0400
In-Reply-To: <20060601185244.GH5869@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Jeff,

You bring up a good point in the fact that I believe your refering to 
detecting 80 wire vs. 40 wire.  We've not tried to use this to our 
advantage, but it could have some merrit.  What does the driver do if it 
encounters a 40 wire cable and the drive says it's capable of DMA5?

Best wishes,
John


From: Jeff Garzik <jeff@garzik.org>
To: John Treubig <jtreubig@hotmail.com>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Controlling PATA access speeds
Date: Thu, 1 Jun 2006 14:52:44 -0400

On Thu, Jun 01, 2006 at 12:25:45PM -0500, John Treubig wrote:
 > We are currently using Promise Ultra133 TX2 (PDC20269 chip; pata_pdc2027x
 > driver, kernel version 2.6.15) to test and access PATA drives.   If my
 > understanding is correct, during boot, a drive is queryied to determine
 > it's maximum access speed and the driver sets the access speed to be no
 > higher than the drive can handle.  This is not speed testing the drive, 
but
 > just the drive firmware reporting it's maximum designed transfer rate.  
Due
 > to design constraints of the cabling to the drives, we need to force the
 > access speed lower than what the Drive reponds.  Is there a mechanism to
 > tell the driver/LibATA to set the access speed to go no higher than a 
value
 > I supply? This can be a static setting that is set at boot, as it does 
not
 >  need to be a dynamic setting.

The driver includes code to do cable detect.  Is this insufficient for
some reason?

	Jeff


