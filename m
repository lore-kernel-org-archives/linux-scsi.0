From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 31 Jul 2003 17:40:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F28C7FD.9030204@cyberone.com.au>
References: <20030716132036.GB833@suse.de>	 <1058364455.1856.28.camel@mulgrave> <20030716 170456.GK833@suse.de>	 <20030717015756.135a3f5a.akpm@osdl.org> <2003071708595 2.GX833@suse.de>	 <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@su se.de>	 <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>	 <3F16 83F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>	 <3F168846.90902 @cyberone.com.au>	 <1058474814.4638.11.camel@markh1.pdx.osdl.net>	 <1058481553 .19508.5.camel@markh1.pdx.osdl.net>	 <1058485621.7424.30.camel@dell_ss5.pdx.o sdl.net>	 <20030717170055.5dbe20c1.akpm@osdl.org> <3F17821A.307@cyberone.com. au>	 <20030717222534.0295c44e.akpm@osdl.org> <3F1785D9.5000905@cyberone.com.au>	 <1058537776.1863.6.camel@mulgrave>  <20030718093006.5e07b6e2.akpm@osdl.org>	 <1058546495.1863.57.camel@mulgrave> <1058549104.19558.63.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-243-68.webone.com.au ([210.9.243.68]:28947 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S272807AbTGaHlK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 03:41:10 -0400
In-Reply-To: <1058549104.19558.63.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, daniel@osdl.org, markh@osdl.org, Jens Axboe <axboe@suse.de>, cliffw@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>



Alan Cox wrote:

>On Gwe, 2003-07-18 at 17:41, James Bottomley wrote:
>
>>On Fri, 2003-07-18 at 11:30, Andrew Morton wrote:
>>
>>>Nick is probably on a plane by now.  I sent Mark's original one-liner to
>>>Linus last night.
>>>
>>That's not a fix, it only catches one out of the five requeue cases in
>>SCSI.
>>
>>why don't we just use the deadline elevator until this can be sorted out
>>properly?
>>
>
>For aacraid you can just throw commands at the card, its got a 233Mhz
>ARM and a mind of its own anyway
>
>

The problem that AS solves isn't that a card/disk doesn't know what
to do with the requests it has, its that they don't know what requests
they are going to get (likely to get).

On the other hand high end SCSI devices running database stuff often
take some performance hit when using AS vs deadline.


