From: Samuel Flory <sflory@rackable.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Mon, 30 Dec 2002 13:06:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E10B538.3020408@rackable.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com> <176730000.1040430221@aslan.btc.adaptec.com> <3E03BB0D.5070605@rackable.com> <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva> <20021228091608.GA13814@louise.pinerecords.com> <Pine.LNX.4.50L.0212281131580.26879-100000@imladris.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rik van Riel <riel@conectiva.com.br>
Cc: Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

Rik van Riel wrote:

>On Sat, 28 Dec 2002, Tomas Szepe wrote:
>
>  
>
>>Marcelo, you've been overlooking these updates for a bit too long now
>>for your "let's throw them at -ac" to sound fair.  IMHO of course.  Also
>>remember those are both production drivers tested thoroughly in FreeBSD,
>>    
>>
>
>Are we talking about the old or the new aic7xxx driver ?
>
>If it's the new driver, it's breaking on WAY too many
>machines and I have no idea why it got ever merged...
>  
>

  Well it might have had sometime to do with the way the old driver 
tended to lockup under heavy load.

>I have yet to see a machine where the new aic7xxx driver
>works. I'm sure they exist, but it doesn't work on any
>of the machines I have access to.
>
>  
>

  Funny the reverse is true for me .  It works for every system I have 
access to.

-- 
There is no such thing as obsolete hardware.
Merely hardware that other people don't want.
(The Second Rule of Hardware Acquisition)
Sam Flory  <sflory@rackable.com>



