From: Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 13:43:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070109807.1609.5.camel@work.thl.home>
References: <Pine.LNX.4.44.0311282118550.528-100000@poirot.grange>
	 <1070103829.1704.2.camel@work.thl.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.hi-online.de ([193.254.18.34]:61153 "EHLO
	mail01.htp-tel.de") by vger.kernel.org with ESMTP id S263742AbTK2MmP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 07:42:15 -0500
In-Reply-To: <1070103829.1704.2.camel@work.thl.home>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chiaki <ishikawa@yk.rim.or.jp>, linux-scsi@vger.kernel.org

Am Sa, den 29.11.2003 schrieb Thorsten Leemhuis um 12:03:
> [Hi linux-scsi, I mailed with Guennadi in private before as I tried the
> driver before it was posted to the list] 
> 
> Am Fr, den 28.11.2003 schrieb Guennadi Liakhovetski um 21:25: 
> > Further to your tests, Thorsten: just tried cdecord v. 2.00.3 under 2.4.21
> > and (the same command) under 2.6.0-test7. Worked under 2.4, failed under
> > 2.6. However, I tried it with an ATAPI CDRW, but still, it indicates, that
> > cdrecord is still not quite functional under 2.6. I did get some error
> > messages under 2.4:
> > 
> > Error: Illegal request -- (Sense key=0x05)
> > 
> > which, presumably, means some unsupported command, but still it worked. I
> > should look through LKML archives regarding cdrecord under 2.6, or anybody
> > can give a short info?
> 
> PEBKAC
> 
> I just found the problem, was my fault -- the module sg was not loaded,
> in 2.4 this was done automatically. Will have to check my
> module-configuration...
> 
> Will try to burn now. Sorry for the noise.

Burning went fine without problems, a bit-wise compare was fine. 

Tried to scan, there the machine locks up. But this happens in 2.4 also,
maybe it's hardware-problem. From my point of view I think investigating
further here is lost time.

Thanks for your work Guennadi!

CU
thl

