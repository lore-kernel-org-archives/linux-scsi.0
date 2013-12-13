From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Help with mpt2sas kernel message
Date: Thu, 12 Dec 2013 20:32:27 -0500
Message-ID: <20131213013227.GC6136@animx.eu.org>
References: <20131212170459.GD13674@animx.eu.org>
 <CAF2xp_EbEkaR3+2ac8+yvLVyEw548890tknLDa5yGyRGfp88EQ@mail.gmail.com>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:45618 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3LMBc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Dec 2013 20:32:29 -0500
Content-Disposition: inline
In-Reply-To: <CAF2xp_EbEkaR3+2ac8+yvLVyEw548890tknLDa5yGyRGfp88EQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Chang <dpf@google.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Peter Chang wrote:
> 2013/12/12 Wakko Warner <wakko@animx.eu.org>:
> > Kernel: vanilla 3.7.2.
> >
> > I have 2 mpt2sas controllers.  I'm running a md check on the 2 arrays that I
> > have (one per card).  I'm seeing this in my kernel log (last 4 lines):
> > 2013-12-10 19:52:10 kame kernel:[1558186.193904] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
> 
> 'all ncq IOs fail when one ncq io encounters an error'

Can you point me to a list of codes?  Is this message something that I
should be concerned about?  I haven't seen this message before, however, I
changed all the disks in the array and replaced the controller (The mptsas
wouldn't support 3tb disks).  The chassis is external and the card has 2
external minisas connectors.  About the only thing that didn't change was
the chassis and the computer.

> > I'd also like to know which card mpt2sas0 is.  Is it the one that has the
> > lower numbered pci bus?
> 
> it's the first controller enumerated on pci, so probably the lowest number.

That would be the 2 minisas controller then.  The disks on this controller
is 8x 3tb in raid6 with 128k chunk.

Thanks for your response.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
