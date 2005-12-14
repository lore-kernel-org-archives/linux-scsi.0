From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws,
	PCI	coherency	problem
Date: Wed, 14 Dec 2005 09:29:16 -0800
Message-ID: <1134581356.3278.1.camel@mulgrave>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>
	 <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave>
	 <439E0112.1030801@sgi.com>  <439ECB2E.7070103@sgi.com>
	 <1134485413.3356.2.camel@mulgrave> <439F0FD6.30701@sgi.com>
	 <439FA708.9070508@c-lab.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45994 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932157AbVLNR3l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 12:29:41 -0500
In-Reply-To: <439FA708.9070508@c-lab.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Joosten <michael.joosten@c-lab.de>
Cc: Michael Reed <mdr@sgi.com>, pazke@donpac.ru, linux-scsi@vger.kernel.org

On Wed, 2005-12-14 at 06:00 +0100, Michael Joosten wrote:
> >Perhaps Mr. Joosten can confirm his failing case with the UP kernel?
> >
> >  
> >
> OK, I'm currently doing this, though with a Fedora Core3 kernel 
> (2.6.12-1.1381-FC3) UP and SMP,  running it with some ooold filesystem 
> benchmark on a similarly old PIII 500MHz board. What else is possible is 
> an Intel dual PII (450MHz) server board (N440BX) , a dual PIII(730MHz) 
> workstation and a very recent one with hyperthreading PIV. I'm currently 
> using a distributed kernel with modules, because this version still has 
> the mmiowb() in place (I hope!) .
> There might be a timing issue (the faults happend somehow earlier once 
> the board and the VisWS got warmer), but I hope that the other platforms 
> will show a little difference...
> Well, the PIII board with both a 550 and a 800 MHz proc showed no 
> difference, the driver just *works*, no failure in 20 runs.  It looks 
> like the problem only shows up in the VISWS. Perhaps I try it again 
> putting the QLA1080 in the 32bit slot, which is apparently not 
> controlled by the Lithium, but rather a plain PIIX chip. And perhaps 
> some other platform and chipset.

Yes, the PIO posting issue is VISWS only, I think.  Could you confirm
that your original bug report was on a SMP VISWS, and could you try the
tests over using a UP kernel on the VISWS?

Thanks,

James


