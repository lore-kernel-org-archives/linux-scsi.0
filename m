From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.5.70-mm2: g_NCR5380 link errors
Date: Fri, 30 May 2003 00:15:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030529221526.GL5643@fs.tum.de>
References: <20030529012914.2c315dad.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:6092 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S262903AbTE2WCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 18:02:16 -0400
Content-Disposition: inline
In-Reply-To: <20030529012914.2c315dad.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

It seems the following compile error comes from Linus' tree:

<--  snip  -->

...
drivers/scsi/g_NCR5380_mmio.o(.text+0x5a0): In function 
`notyet_generic_proc_info':
: multiple definition of `notyet_generic_proc_info'
drivers/scsi/g_NCR5380.o(.text+0x5a0): first defined here
drivers/scsi/g_NCR5380_mmio.o(.text+0x2d20): In function 
`generic_NCR5380_proc_info':
: multiple definition of `generic_NCR5380_proc_info'
drivers/scsi/g_NCR5380.o(.text+0x2d20): first defined here
make[2]: *** [drivers/scsi/built-in.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

