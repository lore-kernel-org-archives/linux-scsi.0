From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.13-rc6-mm1: drivers/scsi/aic7xxx/ compile error
Date: Fri, 19 Aug 2005 18:40:36 +0200
Message-ID: <20050819164036.GE3682@stusta.de>
References: <20050819043331.7bc1f9a9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37135 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932554AbVHSQkj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 12:40:39 -0400
Content-Disposition: inline
In-Reply-To: <20050819043331.7bc1f9a9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

<--  snip  -->

...
  LD      drivers/scsi/aic7xxx/built-in.o
drivers/scsi/aic7xxx/aic79xx.o: In function `aic_parse_brace_option':
: multiple definition of `aic_parse_brace_option'
drivers/scsi/aic7xxx/aic7xxx.o:: first defined here
make[3]: *** [drivers/scsi/aic7xxx/built-in.o] Error 1

<--  snip  -->


#includ'ing .c files is considered harmful...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

