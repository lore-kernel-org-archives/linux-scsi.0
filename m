Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEEAC4707F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795C4613AD
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhEVImQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5663 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhEVImH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:07 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnH0x1wWtz1BPyG;
        Sat, 22 May 2021 16:37:53 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:41 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 23/24] scsi: dc395x: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:27 +0800
Message-ID: <1621672648-39955-24-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
References: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/dc395x.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index be87d5a..ccdbbf9 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -724,10 +724,10 @@ static struct DeviceCtlBlk *dcb_get_next(struct list_head *head,
 		}
 	/* if no next one take the head one (ie, wraparound) */
 	if (!next)
-        	list_for_each_entry(i, head, list) {
-        		next = i;
-        		break;
-        	}
+		list_for_each_entry(i, head, list) {
+			next = i;
+			break;
+		}
 
 	return next;
 }
@@ -4370,13 +4370,13 @@ static int adapter_init(struct AdapterCtlBlk *acb, unsigned long io_port,
 
 	/* get eeprom configuration information and command line settings etc */
 	check_eeprom(&acb->eeprom, io_port);
- 	print_eeprom_settings(&acb->eeprom);
+	print_eeprom_settings(&acb->eeprom);
 
 	/* setup adapter control block */	
 	adapter_init_params(acb);
 	
 	/* display card connectors/termination settings */
- 	adapter_print_config(acb);
+	adapter_print_config(acb);
 
 	if (adapter_sg_tables_alloc(acb)) {
 		dprintkl(KERN_DEBUG, "Memory allocation for SG tables failed\n");
@@ -4641,12 +4641,12 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		dprintkl(KERN_INFO, "scsi_host_alloc failed\n");
 		goto fail;
 	}
- 	acb = (struct AdapterCtlBlk*)scsi_host->hostdata;
- 	acb->scsi_host = scsi_host;
- 	acb->dev = dev;
+	acb = (struct AdapterCtlBlk*)scsi_host->hostdata;
+	acb->scsi_host = scsi_host;
+	acb->dev = dev;
 
 	/* initialise the adapter and everything we need */
- 	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
+	if (adapter_init(acb, io_port_base, io_port_len, irq)) {
 		dprintkl(KERN_INFO, "adapter init failed\n");
 		goto fail;
 	}
@@ -4660,7 +4660,7 @@ static int dc395x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 	pci_set_drvdata(dev, scsi_host);
 	scsi_scan_host(scsi_host);
-        	
+
 	return 0;
 
 fail:
-- 
2.8.1

