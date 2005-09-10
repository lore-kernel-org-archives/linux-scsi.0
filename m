From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Sat, 10 Sep 2005 15:08:33 +0200
Message-ID: <1126357713.3222.149.camel@laptopd505.fenrus.org>
References: <20050910041218.29183.qmail@web51612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12494 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750813AbVIJNIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 09:08:48 -0400
In-Reply-To: <20050910041218.29183.qmail@web51612.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luben_tulkov@adaptec.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>


> No self respecting SAS chip would not do 64 bit DMA, or have an sg tablesize
> or any other limitation.

yet... there will be :)
> 
> Naturally, aic94xx has _no limitations_. :-)  But hey, our hardware just
> kicks a*s!

if it has no such limits then it indeed does!


> (Oh, I know, the solution you're paid to push into the kernel
> doesn't need those since it does all SAS in the firmware.)

I think you are way out of line here. James is very prudent in
separating his job at SteelEye and his maintainership.


> Hmm, lets see:
> I posted today, a _complete_ solution, 1000 years ahead of this
> "embryonic SAS class" you speak of.

yet you post this without having had ANY discussion or earlier reviews
in the recent months. IN fact to the outside world it looks like you sat
on this code for a long time for competative reasons and just posted it
now that Christoph is getting his layer finished.


> Furthermore, why do you want to use a downgrade solution?
> 
> The answer is simple:
>    After "emd", Dell (Hi Matt!) learned quickly that if they want something
> in SCSI Core, they have to hire the people who _make_the_decisions_ what
> goes in and stays out of SCSI Core, to write that something, irrespectively

well EMD's failure was 100% Adaptecs fault. Adaptec was warned EARLY ON
that a dmraid like solution was going to be needed. It was just that
Adaptec decided to ignore this advice (and focus only on 2.4 and ignore
2.6 entirely) that caused Adaptec to waste all the time and money on it.
 

> So as long as *you are on their payroll*, what are you discussing here

James is paid by SteelEye. Not by Dell or LSI.

> with me?  *You have an agenda*!

so do you.

> I long for the days of the previous maintainer.

What previous maintainer?


