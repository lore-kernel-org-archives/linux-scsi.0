From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: slow external firewire drive
Date: Sun, 30 Oct 2005 08:47:37 +0100
Message-ID: <43647A99.60607@s5r6.in-berlin.de>
References: <20051027015655.GC14010@toucan.gentoo.org> <43608663.7020103@s5r6.in-berlin.de> <20051027124154.GD14010@toucan.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46278 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932773AbVJ3Hs6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Oct 2005 02:48:58 -0500
In-Reply-To: <20051027124154.GD14010@toucan.gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric Edgar <rocket@gentoo.org>

Eric Edgar wrote on 2005-10-27:
> I have tried the different serialize_io option and it didnt help much.
> 
> it is a s400 based card.
> 
> Here are the numbers off the 2 biggest chips on the card.
> 
> belkin f5u503
> 
> CHIP 1
> tsb12lv26
> ca-22a752t
> f731652a
> 
> CHIP 2 
> 22any0ct
> tsb41ab3
...

I have not heard anything negative about Belkin hardware so far. Also, 
TI lists only one erratum concerning the TSB41AB3 which is not related 
to the low throughput. The culprit is probably either the Maxtor 
FireWire enclosure (PHY, link layer controller & IDE bridge, firmware, 
or perhaps even the included HDD) or our software...

>>> Vendor: Maxtor    Model: 1394 storage      Rev: v1.3
>>> Type:   Direct-Access-RBC                  ANSI SCSI revision: 04
>>>SCSI device sda: 156355584 512-byte hdwr sectors (80054 MB)
...
>>>hdparm -tT /dev/sda
>>>
>>>/dev/sda:
>>>Timing cached reads:   644 MB in  2.01 seconds = 320.40 MB/sec
>>>Timing buffered disk reads:    8 MB in  3.09 seconds =   2.59 MB/sec
...
>>>2.6.14-rc4
>>> 
>>>I dont seem to see any error messages ... just bad performance.

Maxtor's currently available enclosures are noticeable slower than 
comparable products:
http://www.macworld.com/2005/10/reviews/firewiremain/index1.php
Although according to these application test on OS X, they should not be 
as extremely slow as hdparm measures.

I remember though that Maxtor FireWire drives have been used under Linux 
before. Alas www.linux1394.org and its hardware compatibility list are 
offline again at the moment.

That is all I can say about it so far.
-- 
Stefan Richter
-=====-=-=-= =-=- ====-
http://arcgraph.de/sr/
