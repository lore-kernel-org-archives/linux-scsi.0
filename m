From: "Haofeng Kou" <haofengk@ptu.promise.com>
Subject: RE: Disk Exerciser
Date: Mon, 8 Apr 2002 14:03:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F6A3AFC9BCD92E48B79C14E4AAAEA20F12C539@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

The iozone doesn't access the SCSI drive's IO, but it keep display the
data without error report.

Anyone has meet this before?

-----Original Message-----
From: Aron Zeh [mailto:ARZEH@de.ibm.com] 
Sent: Tuesday, April 02, 2002 3:25 PM
To: Haofeng Kou
Cc: linux-scsi@vger.kernel.org
Subject: Re: Disk Exerciser




Hello Haofeng,

I think Iozone (www.iozone.org) or
bonnie++(http://www.coker.com.au/bonnie++/) might just do the trick.

Aron

"Haofeng Kou" <haofengk@ptu.promise.com>@vger.kernel.org on 04/03/2002
12:41:06 AM

Please respond to "Haofeng Kou" <haofengk@ptu.promise.com>

Sent by:    linux-scsi-owner@vger.kernel.org


To:    <linux-scsi@vger.kernel.org>
cc:
Subject:    Disk Exerciser


Dear         friends,

Any one know certain Disk Exerciser tools, which can be used to test the
performance of the SCSI RAID Controller for the HardDisk? The tools need
to be running on the Linux for the Xscale(IQ80310) board, also the
source code is necessary for me because I plan to modify it suitable for
my project.



Thanks!
haofeng
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html




