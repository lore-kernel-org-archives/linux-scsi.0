From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: Fw: advansys.c problems in 2.6.0-test2
Date: Sat, 2 Aug 2003 21:09:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308022109.31991.gene.heskett@verizon.net>
References: <20030802130522.0b517fa9.akpm@osdl.org> <1059857308.20306.2.camel@dhcp22.swansea.linux.org.uk>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop018pub.verizon.net ([206.46.170.212]:5000 "EHLO
	pop018.verizon.net") by vger.kernel.org with ESMTP id S270469AbTHCBJh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2003 21:09:37 -0400
In-Reply-To: <1059857308.20306.2.camel@dhcp22.swansea.linux.org.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Saturday 02 August 2003 16:48, Alan Cox wrote:
>On Sad, 2003-08-02 at 21:05, Andrew Morton wrote:
>> You'll need to Cc: the linux-scsi folks for the advansys problem.
>>
>> Do any of the SCSI maintaniers actually have Advansys hardware?
>>
>> Is the vendor actively maintaining the driver?  It seems not.
>
>I've got hardware,  I don't currently have time to let 2.6 near
>it because I need it to work.

My situation too.

> I'd guess Advansys may send patches
>at some point once 2.6 is being considered for vendor trees.
>They've never sent many code drops, just 3 or 4 trees that plain
>and simple worked.

That they did indeed, till 2.6...

Unforch Alan, this is the body of the message I just got from who they 
have turned into (initio).  I found it in my junquemail folder, which 
means one of my 100 or so spam filter rules was triggered.

---
<Advansys/Connectcom went bankrupt in 2001 and is no longer in 
business.
We (Initio Corp) purchased the rights to some of their SCSI products
from the bank, however, your adapter was not included. Since we do not
have any drivers or information on your adapter there is no longer any
support for it.>

To purchase a newer model supported under the latest operating 
systems,
visit our store at www.initio.com . 
Regards,

Shelly Baldwin 
Inside Sales 
Initio Corporation 
Maker of AdvanSysTM SCSI products 

Tel:  1-800-994-6484 ext. 573 
Fax:  408-245-7112 
---

It also had the usual lawyer boilerplate about this message is 
confidential etc, etc, etc.  As you can see, I'm the King of Siam 
too...  Maybe when pigs fly :)  I haven't been there to check, but 
I'm taking micro-bets linux support for the newer cards does not 
exist.  And I just took a look, semi-zip, certainly not for an 
ABP-930.  Sigh..

-- 
Cheers Alan, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

