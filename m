From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.5.74: aha1740.c doesn't compile
Date: Thu, 3 Jul 2003 12:18:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030703101846.GH282@fs.tum.de>
References: <Pine.LNX.4.44.0307021433520.2323-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:45796 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S265925AbTGCKEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 06:04:33 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0307021433520.2323-100000@home.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Marc Zyngier <mzyngier@freesurf.fr>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

drivers/scsi/aha1740.c fails to build on 2.5.74 withthe following error:

<--  snip  -->

...
  CC      drivers/scsi/aha1740.o
drivers/scsi/aha1740.c: In function `aha1740_queuecommand':
drivers/scsi/aha1740.c:378: error: request for member `magic' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `lock' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `babble' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `babble' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `module' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `owner' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `oline' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `lock' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `owner' in 
something not a structure or union
drivers/scsi/aha1740.c:378: error: request for member `oline' in 
something not a structure or union
drivers/scsi/aha1740.c:397: error: request for member `magic' in 
something not a structure or union
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

