From: Alex Williamson <alex.williamson@hp.com>
Subject: RE: mptscsih.c: discarded in section `.exit.text' from drivers/bu
	ilt-in.o
Date: Thu, 05 Feb 2004 13:20:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076012402.3744.97.camel@patsy.fc.hp.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703D1A5D4@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:41173 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S266408AbUBEUUJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 15:20:09 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703D1A5D4@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Eric,

   2.6, the very latest in Linus' linux-2.5 bk tree.  Thanks,

	Alex

On Thu, 2004-02-05 at 13:15, Moore, Eric Dean wrote:
> Are you using 2.6 or 2.4 kernel?  I have recently
> posted different patches against both kernel trees.
> I need to know with driver version your on.
> 
> Eric
> 
> On Thursday, February 05, 2004 12:53 PM, Alex Williamson wrote:
> > 
> >    The MPT Fusion driver seems to have developed a linker problem on
> > ia64.  The latest linux-2.5 bk tree gives me the following:
> > 
> >   LD      .tmp_vmlinux1
> > local symbol 0: discarded in section `.exit.text' from 
> > drivers/built-in.o
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Running the reference discard checking tool:
> > 
> > $ ~/reference_discarded.pl 
> > Finding objects, 858 objects, ignoring 0 module(s)
> > Finding conglomerates, ignoring 81 conglomerate(s)
> > Scanning objects
> > Error: ./drivers/message/fusion/mptscsih.o .init.text refers 
> > to 00000000000001e2 PCREL21B          .exit.text
> > Done
> > 
> > And, sure enough, if I remove the __exits from mptscsih_exit() I get a
> > linkable kernel.  Looks like the __exits ought to be removed.  Thanks,
> > 
> > 	Alex
> > 
> > -- 
> > Alex Williamson                             HP Linux & Open Source Lab
> > 
-- 
Alex Williamson                             HP Linux & Open Source Lab

