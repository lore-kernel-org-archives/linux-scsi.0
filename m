From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: Best driver for qlogic 2200 fc?
Date: Tue, 18 Nov 2003 20:19:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069183192.4927.3.camel@cala>
References: <200311171711.36441.mgiammarco@virgilio.it>
	 <1069085218.14602.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp4.tin.it ([212.216.176.224]:41137 "EHLO vsmtp4.tin.it")
	by vger.kernel.org with ESMTP id S263770AbTKRTUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 14:20:01 -0500
In-Reply-To: <1069085218.14602.63.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Craig Tierney <ctierney@hpti.com>, linux-scsi@vger.kernel.org

Il lun, 2003-11-17 alle 17:06, Craig Tierney ha scritto:

> > Unfortunately it gives me slow performance (sequential read of 30mb/sec on a 
> > seagate 318452fc that can do 60mb/sec sequential read).
> > 
> 
> What is your write performance?  Have you tried
> to tune /proc/sys/vm/{min,max}-readahead?

I have tuned readahead and not it goes 50 mb.
I am shocked, why I need to tune it?
Usually I do an hdparm -t -T to see if hard disk is good
(and eventually hdparm again to tune ide interface)
Without tuning I can reach sequential read of more than 60 mb using raid0.
I do not understand why the OS cannot use the full speed of this FC drive.

OTOH side I discovered that (in a raid1 array ) the two seagate write speed is very low: 10mb/s, why?

