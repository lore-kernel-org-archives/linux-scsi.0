From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.6.8-rc3: MPT Fusion compile error with PROC_FS=n
Date: Fri, 6 Aug 2004 21:57:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040806195755.GA2746@fs.tum.de>
References: <Pine.LNX.4.58.0408031505470.24588@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:60918 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S268258AbUHFT6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2004 15:58:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0408031505470.24588@ppc970.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, sjralston1@netscape.net, mpt_linux_developer@lsil.com
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

The "MPT Fusion driver 3.01.09 update" in 2.6.8-rc causes the following 
compile error with CONFIG_PROC_FS=n:

<--  snip  -->

...
  CC [M]  drivers/message/fusion/mptbase.o
drivers/message/fusion/mptbase.c: In function `mptbase_probe':
drivers/message/fusion/mptbase.c:1394: `procmpt_iocinfo_read' undeclared 
(first use in this function)
drivers/message/fusion/mptbase.c:1394: (Each undeclared identifier is 
reported only once
drivers/message/fusion/mptbase.c:1394: for each function it appears in.)
drivers/message/fusion/mptbase.c:1399: `procmpt_summary_read' undeclared 
(first use in this function)
drivers/message/fusion/mptbase.c: In function `mpt_do_ioc_recovery':
drivers/message/fusion/mptbase.c:1626: warning: `r' might be used 
uninitialized in this function
drivers/message/fusion/mptbase.c: In function `GetIocFacts':
drivers/message/fusion/mptbase.c:2419: warning: unknown conversion type 
character `z' in format
drivers/message/fusion/mptbase.c:2419: warning: too many arguments for 
format
make[3]: *** [drivers/message/fusion/mptbase.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

