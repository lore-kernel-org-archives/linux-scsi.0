From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 12:07:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211207.16900.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:44230 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267785AbUIUQHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:07:30 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 11:58 am, Andrew Vasquez wrote:
>  #define WRT_REG_WORD_PIO(addr, data) (outw(data,(unsigned long)addr))
>
> that are used to access flash/gpio registers of an ISP2312v2 chip due to
> some hardware problems.  I can post a patch for the soft-reset issue using
> these macros?  Which tree shall I use as a base, several patches have been
> floating around which 'fix' the issue on SN2 paltforms, but also remove
> what has been called 'excessive', or 'unnecessary' readw()s?

I think changing the reset writes into PIO writes using the above macro, along 
with a udelay to wait for the card, is as close as we're going to get to 
solving this problem.

Jesse
