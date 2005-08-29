From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fix compiler warning in aic7770
Date: Tue, 30 Aug 2005 01:15:36 +0200
Message-ID: <200508300115.47618.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.192]:46388 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751347AbVH2XO6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 19:14:58 -0400
Received: by zproxy.gmail.com with SMTP id r28so715172nza
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 16:14:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Fix compiler warning in drivers/scsi/aic7xxx/aic7770.c : 
   drivers/scsi/aic7xxx/aic7770.c:129: warning: unused variable `l'

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic7770.c |    1 -
 1 files changed, 1 deletion(-)

--- linux-2.6.13-orig/drivers/scsi/aic7xxx/aic7770.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.13/drivers/scsi/aic7xxx/aic7770.c	2005-08-30 01:08:22.000000000 +0200
@@ -126,7 +126,6 @@ aic7770_find_device(uint32_t id)
 int
 aic7770_config(struct ahc_softc *ahc, struct aic7770_identity *entry, u_int io)
 {
-	u_long	l;
 	int	error;
 	int	have_seeprom;
 	u_int	hostconf;

