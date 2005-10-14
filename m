From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Fri, 14 Oct 2005 20:47:23 +0200
Message-ID: <1129315644.5359.7.camel@laptopd505.fenrus.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
	 <20051013231614.27191.9897.sendpatchset@plap.qlogic.com>
	 <1129275031.2873.3.camel@laptopd505.fenrus.org>
	 <20051014162701.GA19098@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59373 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750867AbVJNSrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 14:47:32 -0400
In-Reply-To: <20051014162701.GA19098@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>


> > 
> > as one of the people who made significant changes to the qlogic driver I
> > object to this license change, especially because it was a one sided
> > change without consultation beforehand.
> > 
> > James: please do not apply this.
> > 
> > Andrew: you can't do this. You just CANNOT change the license of code
> > you don't own fully without consent of ALL contributors.
> 
> During my talk at OLS, I had mentioned that QLogic Legal was
> investigating solutions to the firmware-blob licensing issue with
> respect to the qla2xxx driver. 

this is a really odd way to "solve" this, simply because by being part
of the kernel tarbal, the GPL clause is the only one that matters (see
the GPL text for collective works) and the BSD part of it is "dormant"
until someone takes the driver outside the linux kernel context.
So that isn't solving anything with respect to the firmware licensing
issue/non-issue (depending from what angle you look at it)


> Since then, the license was was working its way through the
> slow-moving pipelines of Legal.  During this time, it was my
> understanding that the document had been vetted my several OEMs and
> major distros

this is all irrelevant :)

> .  Granted, I can understand that this would certainly
> not get the broad exposure of the linux-kerne|scsi ditributions (which
> if I'm reading correctly is one of your major concerns). 

no my concern is that you failed to get consent from all people who
contributed to the driver.



>   Given the heritage of the qla2xxx driver,
> one concerns is -- at what point does one claim that total
> contributors acceptance has been achieved given a proposed licensing
> change.

you need 100% of the people who contributed substantial changes. And
even then it's a questionable change, given that the driver clearly is a
derived work of the linux kernel (and that's fine, it's GPL) and is
shipped with the linux kernel (see clause 2 of the GPL). Other licenses
are not relevant as long as the driver is a linux kernel driver like
this.

You need 100% because you are giving 3rd parties more rights the code
than that the contributors have given you. That just can't be done
without consent.



If you want the firmware issue improved, make the *firmware* BSD
licensed. And only the firmware. But leave the driver GPL.
And probably make it optional and allow a request_firmware() interface
as well, so that people/distributions who don't want the built in one
can use the request_firmware() option instead.



