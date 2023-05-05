Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB6BC77B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 01:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjEEBmH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 21:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjEEBmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 21:42:06 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B923900D;
        Thu,  4 May 2023 18:42:02 -0700 (PDT)
X-QQ-mid: bizesmtpipv602t1683250900tk1o
Received: from localhost ( [255.182.231.6])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 05 May 2023 09:41:38 +0800 (CST)
X-QQ-SSF: 0140000000000090C000000A0000000
X-QQ-FEAT: v5d6m16HONU7LAjIfgPa2Q3d/fS5zK/DqxOzftP5hUR3wSELEAOXzE8Cf+j+b
        y4lzgvU/ihMtIDQ0+Olo7La4n7cwCvPubixZWDee1e/QHyc0BsBXmor2cBwPAd/xVHw7wZn
        bDSpe/TJ4licbkddoa9k88Vigm9uZ23QX8Uja6M5xzoPzWWujsDuVrjL72xMII27r4cWrf0
        YNwF861thfiUxvaYtvy/9FMDrSq5jFuuozxj5aghA69dIw9g6BaSMpEM+RFNMPDHwv93REA
        O7NjpbOOdxZcbI1qjkc5H+DBiwzRPOliXKLJLSuPPJUK9BGPvoolTVWSQkvo/1CxNWoROQn
        Fs5BlQqtB6oKP8h+4s=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14027049164739534201
Date:   Fri, 5 May 2023 17:41:40 +0800
From:   Wang Honghui <honghui.wang@ucas.com.cn>
To:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi:dc395x: Correct "structures" spelling mistakes
Message-ID: <9721BDA46BD84475+ZFTPVLLFKTMn4lSE@TP-P15V>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpipv:ucas.com.cn:qybglogicsvrgz:qybglogicsvrgz5a-2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Wang Honghui <honghui.wang@ucas.com.cn>

As title.

---
 drivers/scsi/dc395x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c8e86f8a631e..a3f00e6e3296 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3641,7 +3641,7 @@ static void adapter_add_device(struct AdapterCtlBlk *acb,
  * adapter_remove_device - Removes the device instance from the adaptor
  * instance. The device instance is not check in any way or freed by this. 
  * The caller is expected to take care of that. This will simply remove the
- * device from the adapters data strcutures.
+ * device from the adapters data structures.
  *
  * @acb: The adapter device to be updated
  * @dcb: A device that has previously been added to the adapter.
@@ -3980,7 +3980,7 @@ static void trms1040_read_all(struct NvRamType *eeprom, unsigned long io_port)
  * Checks the checksum and if it's not correct it uses a set of default
  * values.
  *
- * @eeprom:	caller allocated strcuture to read the eeprom data into
+ * @eeprom:	caller allocated structure to read the eeprom data into
  * @io_port:	io port to read from
  **/
 static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
@@ -4578,7 +4578,7 @@ static void banner_display(void)
  * dc395x_init_one - Initialise a single instance of the adapter.
  *
  * The PCI layer will call this once for each instance of the adapter
- * that it finds in the system. The pci_dev strcuture indicates which
+ * that it finds in the system. The pci_dev structure indicates which
  * instance we are being called from.
  * 
  * @dev: The PCI device to initialize.
-- 
2.34.1

