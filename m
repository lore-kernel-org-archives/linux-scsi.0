From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.5.70-mm2: NCR53C9x.c doesn't compile
Date: Thu, 29 May 2003 23:17:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030529211757.GJ5643@fs.tum.de>
References: <20030529012914.2c315dad.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030529012914.2c315dad.akpm@digeo.com>
To: Andrew Morton <akpm@digeo.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It seems the following compile error comes from Linus' tree:

<--  snip  -->

...
  CC      drivers/scsi/NCR53C9x.o
drivers/scsi/NCR53C9x.c: In function `esp_proc_info':
drivers/scsi/NCR53C9x.c:896: `SCpnt' undeclared (first use in this function)
drivers/scsi/NCR53C9x.c:896: (Each undeclared identifier is reported only once
drivers/scsi/NCR53C9x.c:896: for each function it appears in.)
drivers/scsi/NCR53C9x.c: In function `esp_do_data':
drivers/scsi/NCR53C9x.c:1840: warning: unused variable `flags'
make[2]: *** [drivers/scsi/NCR53C9x.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
