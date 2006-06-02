From: "John Treubig" <jtreubig@hotmail.com>
Subject: Re: Controlling PATA access speeds
Date: Fri, 02 Jun 2006 15:37:51 -0500
Message-ID: <BAY113-F20C5E81293FCD88D28597DDF910@phx.gbl>
References: <200606012121.k51LLwCa009141@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay113-f20.bay113.hotmail.com ([65.54.168.30]:34995 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S932566AbWFBUhw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jun 2006 16:37:52 -0400
In-Reply-To: <200606012121.k51LLwCa009141@falcon10.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dwm@austin.ibm.com
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Because of my setup, I have had to pull pin 34 (PDIAG) high at the Promise 
to make the Promise think I have a 40 pin cable.  At boot, the Promise 
thinks I have a 40 wire cable installed and gives me a warning, yet when I 
run my program that measures transfer rate in Linux, I still see the same 
data rates as with an 80 wire cable (pin 34 shorted).  Is there any other 
item that I'm missing besides having Pin 34 pulled high?  Does the drive's 
echoing that it is UDMA5 capable have anything to do with it?  Is the fact 
that I'm not carrying pin 34 all the way to the drive causing my problem?

Best wishes,
John


From: Doug Maxey <dwm@austin.ibm.com>
To: "John Treubig" <jtreubig@hotmail.com>
CC: jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Controlling PATA access speeds
Date: Thu, 01 Jun 2006 16:21:58 -0500


On Thu, 01 Jun 2006 15:35:23 CDT, "John Treubig" wrote:
 >Jeff,
 >
 >You bring up a good point in the fact that I believe your refering to
 >detecting 80 wire vs. 40 wire.  We've not tried to use this to our
 >advantage, but it could have some merrit.  What does the driver do if it
 >encounters a 40 wire cable and the drive says it's capable of DMA5?
 >

The presence of a 40 wire cable limits the device to UDMA2 - 33mhz.
See the ATA6 or later on t13.org.

JS20 blades are lackinging the strapping to indicate the devices hanging
off the amd8111 are on the equivalent of 80 wire - 4 inch trace on mb.
In the JS20 case, a quirk will be necessary to run at speeds higher than 
UDMA2.

++doug


