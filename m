From: Matthias Jaenichen <mj2@percomp.de>
Subject: RE: SCSI IO Errors
Date: Tue, 09 Sep 2003 17:54:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030909172104.03feced0@127.0.0.1>
References: <E5DA6395B8F9614EB7A784D628184B200D9A54@hdsmsx402.hd.intel.
 com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.percomp.de ([192.88.4.5]:14470 "HELO gateway.percomp.de")
	by vger.kernel.org with SMTP id S264172AbTIIP6x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2003 11:58:53 -0400
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B200D9A54@hdsmsx402.hd.intel.
 com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-scsi@vger.kernel.org

At 11:10 09.09.03 -0400, Cress, Andrew R wrote:
>You probably should also ask Seagate about the disk firmware rev 0010
>for ST318436LW.

Good guess, but 0010 is the latest according to seagate AND

I just received one of the drives back (replacement, it was just a try) 
with the same rev level.

>It may not be the latest firmware. From what you indicate about the 
>traces, the disk firmware is the most likely at fault.

driver or firmware, that is what I suspected as well.

I did call SEAGATE again! *0010* is the latest available and they say that 
drive is so popular that any problem with tthat rev would have resulted in 
some update.

Thanks!

Matthias

