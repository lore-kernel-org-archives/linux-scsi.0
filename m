From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 1/3] aacraid: linit.c make aac_show_serial_number static
Date: Thu, 08 May 2008 12:08:53 -0700
Message-ID: <1210273733.19279.54.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.184]:47045 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYEHTI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 15:08:58 -0400
Received: by rn-out-0910.google.com with SMTP id e11so326629rng.17
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2008 12:08:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/aacraid/linit.c:865:9: warning: symbol 'aac_show_serial_number' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/aacraid/linit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1f7c836..5797b2c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -862,7 +862,7 @@ static ssize_t aac_show_bios_version(struct device *device,
 	return len;
 }
 
-ssize_t aac_show_serial_number(struct device *device,
+static ssize_t aac_show_serial_number(struct device *device,
 			       struct device_attribute *attr, char *buf)
 {
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(device)->hostdata;
-- 
1.5.5.1.404.g981f6


