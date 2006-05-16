From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: Help: strange messages from kernel on IA64 platform
Date: Tue, 16 May 2006 15:12:51 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD86@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:15338 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750835AbWEPVMz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 17:12:55 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,

Tuesday, May 16, 2006 5:00 PM, Chase Venters wrote:
> It's a trap, which means the CPU is effectively calling that 
> function.
O.K, that's why...
Then, Is there anyway to look up trap table that the CPU has?
> My best suggestion is to figure out what data is at 
> 0xe00000007f3d80dc and 
> what instructions are at 0xa0000002000373b1.
I will try as you suggested.
Thank you very much for comment.

Regards,

> -----Original Message-----
> From: Chase Venters [mailto:chase.venters@clientec.com] 
> Sent: Tuesday, May 16, 2006 5:00 PM
> To: Ju, Seokmann
> Cc: Linux Kernel Mailing List; linux-scsi@vger.kernel.org
> Subject: Re: Help: strange messages from kernel on IA64 platform
> 
> On Tue, 16 May 2006, Ju, Seokmann wrote:
> 
> > Hi,
> >
> > During communication in between application and megaraid driver via
> > IOCTL, the system displays messages which are not easy to 
> track down.
> > Following is one of the messages and same messages with 
> different values
> > are poping up regularly.
> > ---
> > Kernel unaligned access to 0xe00000007f3d80dc ip=0xa0000002000373b1
> > ---
> >
> > I understand the kernel is complaining about the address 
> which is not
> > aligned and, found the message is coming from function
> > 'ia64_handle_unaligned()' in the arch/ia64/kernel/unaligned.c.
> > But, I couldn't find who is calling this function and 
> further details of
> > reasons.
> >
> > Where should I start to figure out it?
> 
> It's a trap, which means the CPU is effectively calling that 
> function. My 
> best suggestion is to figure out what data is at 
> 0xe00000007f3d80dc and 
> what instructions are at 0xa0000002000373b1.
> 
> > Thank you,
> >
> > Seokmann
> 
> Thanks,
> Chase
> 
