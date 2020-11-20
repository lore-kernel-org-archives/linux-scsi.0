Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD85C56202
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 23:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7F82240C
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 23:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgKTXQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:16:20 -0500
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:39770 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726719AbgKTXQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 18:16:19 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D69A7837F24D;
        Fri, 20 Nov 2020 23:16:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: pull06_5d1058b2734f
X-Filterd-Recvd-Size: 1327
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Fri, 20 Nov 2020 23:16:16 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-scsi@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: pm8001: logging neatening
Date:   Fri, 20 Nov 2020 15:16:08 -0800
Message-Id: <cover.1605914030.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce code duplication and generic neatening of logging macros

Joe Perches (2):
  scsi: pm8001: Neaten debug logging macros and uses
  scsi: pm8001: Make implicit use of pm8001_ha in pm8001_printk explicit

 drivers/scsi/pm8001/pm8001_ctl.c  |    7 +-
 drivers/scsi/pm8001/pm8001_hwi.c  | 1370 ++++++++++---------------
 drivers/scsi/pm8001/pm8001_init.c |  102 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  136 ++-
 drivers/scsi/pm8001/pm8001_sas.h  |   45 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 1596 ++++++++++++-----------------
 6 files changed, 1361 insertions(+), 1895 deletions(-)

-- 
2.26.0

