Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEA9C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0EA2067D
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgGLS3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:29:37 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50597 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729104AbgGLS3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 14:29:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7B0A7204255;
        Sun, 12 Jul 2020 20:29:35 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 74jjYyN7puPu; Sun, 12 Jul 2020 20:29:30 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 35351204164;
        Sun, 12 Jul 2020 20:29:28 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH 0/2] scsi_debug: every_nth cleanup, url + version
Date:   Sun, 12 Jul 2020 14:29:25 -0400
Message-Id: <20200712182927.72044-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It was becoming hard to follow exactly when to expect the error
injection facilities in this driver to fire. Sometimes injected
errors just didn't seem to happen.

The error injection design was too complicated for what was
required. Simplify it and make it more consistent. The second
patch in this set does some housekeeping.

Douglas Gilbert (2):
  scsi_debug: every_nth triggered error injection
  scsi_debug: update documentation url and bump version

 drivers/scsi/scsi_debug.c | 237 +++++++++++++++++---------------------
 1 file changed, 104 insertions(+), 133 deletions(-)

-- 
2.25.1

