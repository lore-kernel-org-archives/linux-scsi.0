Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870BCC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6514320722
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VMZeTSP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgGFMeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:34:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038840; x=1625574840;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aa6XVNXMIFXJmt1RWjyA8wyymcdyRgBIGqOz1Hq/Xsg=;
  b=VMZeTSP5jzuJf/bKbPkySA/ttyXzr/Ghw1jxyMuLz8trOd8CDOvZ1lq4
   WEiQi0eScOxy8bawxHXDjl0fDzkHAHbcUmc8h/BcBAvGF5QetvM3hGAf4
   +oYIspKg6p6AE7b51ir1uDXdFEfXcW6QYEBmrtxwKZ8kF6J30GIF+tYTT
   HOrpCfe58mr4yAmk6+t8JPbA2Q7eoXhSWgbE+XEiwqMfFMBIVBJlHtJu5
   NZgZY7p5411DB3Kinxqk6XIB+E3z+4ztcP190+zayAldXuqCs27nFOQPI
   05vwixus9KSJVvLc1QVdXEuPT0nVWDcEr/9CMX/UyNHz1i/EDgOrerNT6
   w==;
IronPort-SDR: EYr5U4WlHocJynE+L8fon+k/Rd1nLSMt4V1g/dN+qTdtfNF4wpUavkTXpfjOuRIDLU7X10UTMi
 FkVDpRjb0ZKrHNmrRDwB303uWG1PveHp8crPqegugv60+qM1p7PzpSwa6HeHRde/1samSo+321
 1Lw08kxOYscE3/9xzgTtQjr0Kd5Pz3edibDVexoVgGmFiXZebHiHK0vmLYI7YJDLPO4ejBhqV0
 tetYuYQ1JJQ+mEyQ7Prhycn7dAIH5yRZNayDZ/F8+MS/uPs/gnEMEurPzINYLS2scJoChGbjrp
 7fE=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052076"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:34:00 +0800
IronPort-SDR: +o1vVOGqu8fucQvXjtJDxLS9ZKd6VAxrIZcxIGSZCFrUgut7Q1jVy0im8htHx/OcdcFBzl9XZp
 gM50KlhuMFVUjB4kwda5/Vxd1lFHRYT+Q=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:08 -0700
IronPort-SDR: JQwybiIHmZw7MGGJ/UxyxGFDHctSlOq41DopoYcRQz4hNsot8QlIoQ6H4Pk1x4gywJK4cbihzj
 AcqDhYcCZB3Q==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:59 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/10] scsi: mpt3sas: Fix kdoc comments format
Date:   Mon,  6 Jul 2020 21:33:58 +0900
Message-Id: <20200706123358.452180-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix kdoc comments format to avoid compiler warnings when compiling with
W=1.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++++++------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 16 ++++++++++------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 96b78fdc6b8a..1d64524cd863 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -190,7 +190,7 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
 
 /**
  * _base_readl_aero - retry readl for max three times.
- * @addr - MPT Fusion system interface register address
+ * @addr: MPT Fusion system interface register address
  *
  * Retry the readl() for max three times if it gets zero value
  * while reading the system interface register.
@@ -817,6 +817,7 @@ mpt3sas_base_coredump_info(struct MPT3SAS_ADAPTER *ioc, u16 fault_code)
  * mpt3sas_base_wait_for_coredump_completion - Wait until coredump
  * completes or times out
  * @ioc: per adapter object
+ * @caller: caller function name
  *
  * Returns 0 for success, non-zero for failure.
  */
@@ -1718,8 +1719,8 @@ _base_interrupt(int irq, void *bus_id)
 
 /**
  * _base_irqpoll - IRQ poll callback handler
- * @irqpoll - irq_poll object
- * @budget - irq poll weight
+ * @irqpoll: irq_poll object
+ * @budget: irq poll weight
  *
  * returns number of reply descriptors processed
  */
@@ -3048,8 +3049,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 /**
  * _base_check_and_enable_high_iops_queues - enable high iops mode
- * @ ioc - per adapter object
- * @ hba_msix_vector_count - msix vectors supported by HBA
+ * @ioc: per adapter object
+ * @hba_msix_vector_count: msix vectors supported by HBA
  *
  * Enable high iops queues only if
  *  - HBA is a SEA/AERO controller and
@@ -5621,6 +5622,7 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int timeout)
  * _base_wait_for_doorbell_int - waiting for controller interrupt(generated by
  * a write to the doorbell)
  * @ioc: per adapter object
+ * @timeout: timeout in seconds
  *
  * Return: 0 for success, non-zero for failure.
  *
@@ -5833,7 +5835,7 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 /**
  * mpt3sas_wait_for_ioc - IOC's operational state is checked here.
  * @ioc: per adapter object
- * @wait_count: timeout in seconds
+ * @timeout: timeout in seconds
  *
  * Return: Waits up to timeout seconds for the IOC to
  * become operational. Returns 0 if IOC is present
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e552838565..07668499ef21 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3660,8 +3660,9 @@ static DEVICE_ATTR_RW(diag_trigger_mpi);
 
 /**
  * drv_support_bitmap_show - driver supported feature bitmap
- * @cdev - pointer to embedded class device
- * @buf - the buffer returned
+ * @cdev: pointer to embedded class device
+ * @attr: unused
+ * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
  */
@@ -3678,8 +3679,9 @@ static DEVICE_ATTR_RO(drv_support_bitmap);
 
 /**
  * enable_sdev_max_qd_show - display whether sdev max qd is enabled/disabled
- * @cdev - pointer to embedded class device
- * @buf - the buffer returned
+ * @cdev: pointer to embedded class device
+ * @attr: unused
+ * @buf: the buffer returned
  *
  * A sysfs read/write shost attribute. This attribute is used to set the
  * targets queue depth to HBA IO queue depth if this attribute is enabled.
@@ -3696,8 +3698,10 @@ enable_sdev_max_qd_show(struct device *cdev,
 
 /**
  * enable_sdev_max_qd_store - Enable/disable sdev max qd
- * @cdev - pointer to embedded class device
- * @buf - the buffer returned
+ * @cdev: pointer to embedded class device
+ * @attr: unused
+ * @buf: the buffer returned
+ * @count: unused
  *
  * A sysfs read/write shost attribute. This attribute is used to set the
  * targets queue depth to HBA IO queue depth if this attribute is enabled.
-- 
2.26.2

