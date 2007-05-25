From: Olaf Hering <olaf@aepfle.de>
Subject: s390 error: implicit declaration of function sg_dma_len
Date: Fri, 25 May 2007 10:22:38 +0200
Message-ID: <20070525082238.GA30876@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57037 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXEYI30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2007 04:29:26 -0400
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 8397A24D0F6
	for <linux-scsi@vger.kernel.org>; Fri, 25 May 2007 08:22:14 +0000 (UTC)
Received: from ibook.aepfle.de (DSL01.83.171.168.82.ip-pool.NEFkom.net [83.171.168.82])
	by mail.mnet-online.de (Postfix) with ESMTP id 11E6A90D2E
	for <linux-scsi@vger.kernel.org>; Fri, 25 May 2007 10:22:17 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Current Linus tree does not compile on s390 because esp_scsi references
unavailable functions.

/dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c: In function `esp_map_dma':
/dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c:338: error: implicit declaration of function `sg_dma_len'
/dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c: In function `esp_cur_dma_addr':
/dev/shm/R/linux-2.6.21/drivers/scsi/esp_scsi.c:357: error: implicit declaration of function `sg_dma_address'

