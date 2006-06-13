From: William Brodie-Tyrrell <william@brodie-tyrrell.org>
Subject: Re: Fw: [Bugme-new] [Bug 6657] New: Domain validation failures on
 aic7xxx
Date: Tue, 13 Jun 2006 20:22:29 +0930
Message-ID: <20060613202229.18871f78.william@brodie-tyrrell.org>
References: <20060606091840.a39afe5a.akpm@osdl.org>
	<1149956760.3335.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 133.195.233.220.exetel.com.au ([220.233.195.133]:28579 "EHLO
	shed.brodie-tyrrell.org") by vger.kernel.org with ESMTP
	id S1750893AbWFMKwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 06:52:35 -0400
In-Reply-To: <1149956760.3335.18.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mbligh@mbligh.org, akpm@osdl.org, linux-scsi@vger.kernel.org


Hi,

I've applied your patch and rebuilt the kernel but it'll be a few days
before I can try it since the machine in question is Very Busy(tm)
right now.


thanks.


Stoned koala bears drooled eucalyptus spit in awe as James Bottomley
said:

> I'd say that's pretty conclusive. The theory being that the WD doesn't
> have a functional echo buffer, or it lies about the size and in either
> case we get errors back not because of a syndrome test failure but
> because of a problem in the WD echo buffer.
> 
> Try this patch for diagnosis only ... what it's doing is disabling the
> echo buffer tests globally.  If everything boots up OK (please send
> dmesg output so I can see what the echo buffer length is), then we get
> to try to figure out if the WD can do any echo buffer tests or if it has
> to be globally blacklisted (not fun ... LVD really shouldn't be
> configured without the echo buffer test of the transmission line).


-- 
William Brodie-Tyrrell

Carpe Diem - fish of the day.

<william@brodie-tyrrell.org>
http://www.brodie-tyrrell.org/
