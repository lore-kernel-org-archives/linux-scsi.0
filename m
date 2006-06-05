From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 6 Jun 2006 00:14:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606060008330.22057@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:8099 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750727AbWFEWOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2006 18:14:37 -0400
In-Reply-To: <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

On Tue, 6 Jun 2006, Lev A. Melnikovsky wrote:

>   On Mon, 5 Jun 2006 at 12:58pm, Guennadi Liakhovetski wrote:
> 
> > I would try raising it to the maximum ((1 << 30) - 1). The goal would be to
> > try to see which command exactly leads to unexpected reselect.
> OK, scsi_logging_level=4294967295
> 
> Now it was very difficult to reproduce the problem, probably due to different
> timing. I have eventually managed to reproduce it, but the log size is over
> 10MB. You can fetch the compressed file (~100KB) from
> http://kapitza.ras.ru/~leva/dc395x.log.bz2

Great! Thanks for the effort! Now, I am very much hoping somebody more 
knowledgeable about SCSI, this driver and / or having the datasheet could 
have a look at the logs. I will do that too but it won't be easy for me to 
understand what's going wrong there.

[skipped the log]

> > > This scanner is the only device on the bus. My understanding is that I
> > > don't
> > > need to manually terminate anything, please correct me if I'm wrong. I can
> > > not
> > The bus has to be terminated on both ends. The HBA is, probably,
> > terminating automatically, but the external end has to be terminated.
> > Either with an external terminator or with a switch / jumper on your
> > scanner.
> OK, let's put it in the following way: I can find neither switches nor jumpers
> in it.

Do you have the manual for the scanner? I don't know, maybe it has an 
automatic internal terminator. If not, you need an external one. It has 2 
SCSI connectors, right?

Thanks
Guennadi
---
Guennadi Liakhovetski
