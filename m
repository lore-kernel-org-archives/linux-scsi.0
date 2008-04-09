From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: errors from mptsas
Date: Wed, 9 Apr 2008 12:32:08 -0400
Message-ID: <20080409163208.GC12283@animx.eu.org>
References: <20080409105343.GA19104@animx.eu.org> <0631C836DBF79F42B5A60C8C8D4E8229FBDC71@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:55350 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYDIQcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2008 12:32:21 -0400
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229FBDC71@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Rick Warner <rick@microway.com>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Wednesday, April 09, 2008 4:54 AM,  Rick Warner wrote:
> > 
> > Join the club.  I have an LSI SAS with 3x 750gb seagate sata drives in
> > raid5.  Does this happen only on your SATA drives or all the drives?
> > Depending on the activity, it would drop one of them out of the
> > array.  I think the problem has been solved for now by changing the
> > queue_depth to 1.
> > 
> > echo 1 > /sys/block/sdX/device/queue_depth
> > 
> > Here's the drives in my system:
> > [0:0:0:0]    disk    ATA      ST3750640AS      E     /dev/sda
> > [0:0:1:0]    disk    ATA      ST3750640AS      E     /dev/sdb
> > [0:0:2:0]    disk    ATA      ST3750640AS      E     /dev/sdc
> > 
> 
> 
> Rick - I thought you said the magic number was 32 for SATA devices?  And
> we confirmed that in the logs you sent yesterday.   Is that correct, or
> did I miss something.

That was ment for me.
>From what I read, the number is 31 for sata drives (I'm not sure about sas
and not sure if it relates to sata drives on a sas controller).
However, I set mine to 1 specifically and have not had a problem.  I'd
rather not try 31 and a drive drop out again.  It takes 4 hours to rebuild
the array and I've had to do it with the system offline.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
