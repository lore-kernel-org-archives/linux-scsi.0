Return-Path: <SRS0=iy+L=WO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8D2C3A589
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 14:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB19C2087E
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 14:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfHROon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Aug 2019 10:44:43 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:18806 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfHROom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Aug 2019 10:44:42 -0400
Received: from localhost.localdomain ([92.140.207.10])
        by mwinf5d11 with ME
        id qekc2000W0Dzhgk03ekd4e; Sun, 18 Aug 2019 16:44:39 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Aug 2019 16:44:39 +0200
X-ME-IP: 92.140.207.10
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: qla4xxx: Avoid usage of duplicated Header Guard
Date:   Sun, 18 Aug 2019 16:44:35 +0200
Message-Id: <20190818144435.2883-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__QLA_NX_H is already used in 'drivers/scsi/qla2xxx/qla_nx.h', so use a
better name for the include headrr guard of 'ql4_nx.h'.
Use __QL4_NX_H

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qla4xxx/ql4_nx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 98fe78613eb7..2b94b39ee95f 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -4,8 +4,8 @@
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
-#ifndef __QLA_NX_H
-#define __QLA_NX_H
+#ifndef __QL4_NX_H
+#define __QL4_NX_H
 
 /*
  * Following are the states of the Phantom. Phantom will set them and
-- 
2.20.1

