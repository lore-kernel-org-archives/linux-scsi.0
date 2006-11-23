From: Adrian Bunk <bunk@stusta.de>
Subject: RFC: adding the SCSI hptiop driver to 2.6.16
Date: Thu, 23 Nov 2006 03:00:29 +0100
Message-ID: <20061123020029.GJ3557@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:15116 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932679AbWKWCA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 21:00:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@highpoint-tech.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

I'd like to add the SCSI hptiop driver to the 2.6.16 tree.

The backport of the driver in 2.6.18 seems to be straightforward.

My questions are:

Is there any reason I miss why this driver might not work in 2.6.16?

I lack the hardware, and I can therefore only test the compilation.
Would anyone who has the hardware be willing to test whether this 
actually works?

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

