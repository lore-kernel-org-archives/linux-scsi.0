From: "Alexandru N. Barloiu" <slak@dale.ro>
Subject: dpt_i2o in 2.6.0_test*
Date: 09 Aug 2003 23:12:40 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060459960.3882.121.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from light.kappa.ro ([194.102.254.118]:2481 "EHLO mx.dale.ro")
	by vger.kernel.org with ESMTP id S275405AbTHIUNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2003 16:13:37 -0400
Received: from astro.dale.ro (localhost [127.0.0.1])
	by mx.dale.ro (Postfix) with SMTP id 70B6F4052D10
	for <linux-scsi@vger.kernel.org>; Sat,  9 Aug 2003 23:16:27 +0300 (EEST)
Received: from hammer.dale.ro (hammer.dale.ro [193.231.198.250])
	by mx.dale.ro (Postfix) with ESMTP id B9BA240519B4
	for <linux-scsi@vger.kernel.org>; Sat,  9 Aug 2003 23:16:26 +0300 (EEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hello,
I just wanted to ask if there is a fix for this.

  CC      drivers/scsi/dpt_i2o.o
drivers/scsi/dpt_i2o.c:32:2: #error Please convert me to
Documentation/DMA-mapping.txt
drivers/scsi/dpt_i2o.c: In function `adpt_install_hba':
drivers/scsi/dpt_i2o.c:977: warning: passing arg 2 of `request_irq' from
incompatible pointer type
drivers/scsi/dpt_i2o.c: In function `adpt_scsi_to_i2o':
drivers/scsi/dpt_i2o.c:2118: structure has no member named `address'
drivers/scsi/hosts.h: At top level:
drivers/scsi/dpt_i2o.c:165: warning: `dptids' defined but not used
make[2]: *** [drivers/scsi/dpt_i2o.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


-- 
Alexandru N. Barloiu <slak@dale.ro>
Dale Media

