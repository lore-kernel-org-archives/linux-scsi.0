From: Adrian Bunk <bunk@fs.tum.de>
Subject: SCSI sg: Questions regarding jiffies usage
Date: Sun, 11 Jul 2004 02:41:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040711004153.GZ28324@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:53472 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266461AbUGKAl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jul 2004 20:41:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Hi,

I have some questions regarding jiffies usage in the SCSI sg driver in 
2.6.7-mm7:


Is there a good reason for the local sg_ms_to_jif/sg_jif_to_ms functions  
instead of using the time.h msecs_to_jiffies/jiffies_to_msecs macros?

In function sg_new_write:
   timeout = sg_ms_to_jif(srp->header.timeout);
How is it possible that srp->header.timeout isn't already
in jiffies?

Why do both sg_add_request and sg_common_write set
  duration = jiffies
?


TIA
Adrian

BTW: Please Cc me on replies.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

