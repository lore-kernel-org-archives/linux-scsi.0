From: Adrian Bunk <bunk@fs.tum.de>
Subject: 2.6: modular scsi/mca_53c9x doesn't work
Date: Sat, 20 Dec 2003 00:17:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031219231712.GB12750@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:11506 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S263692AbTLSXRU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 18:17:20 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

I got the following mesage when trying to build modular a mca_53c9x in 
2.6.0-test11-mm1:

<--  snip  -->

...
*** Warning: "esp_reset" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_abort" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_queue" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esps_in_use" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_initialize" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_allocate" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_intr" [drivers/scsi/mca_53c9x.ko] undefined!
*** Warning: "esp_deallocate" [drivers/scsi/mca_53c9x.ko] undefined!
...

<--  snip  -->

It seems there are some EXPORT_SYMBOL's needed in NCR53C9x.c?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

