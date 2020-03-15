Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF65C10DCE
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8DD7206BE
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgCOJmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:58066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgCOJmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68E77AC91
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2020 09:42:44 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/8] scsi: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:33 +0100
Message-Id: <20200315094241.9086-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

here is a respin of trivial patch series just to convert suspicious
snprintf() usages with the more safer one, scnprintf().

v1->v2: Align the remaining lines to the open parenthesis


Takashi

===

Takashi Iwai (8):
  scsi: aacraid: Use scnprintf() for avoiding potential buffer overflow
  scsi: be2iscsi: Use scnprintf() for avoiding potential buffer overflow
  scsi: fnic: Use scnprintf() for avoiding potential buffer overflow
  scsi: gdth: Use scnprintf() for avoiding potential buffer overflow
  scsi: ipr: Use scnprintf() for avoiding potential buffer overflow
  scsi: megaraid_sas: Use scnprintf() for avoiding potential buffer
    overflow
  scsi: core: Use scnprintf() for avoiding potential buffer overflow
  scsi: smartpqi: Use scnprintf() for avoiding potential buffer overflow

 drivers/scsi/aacraid/linit.c              | 17 ++++-----
 drivers/scsi/be2iscsi/be_mgmt.c           | 20 +++++------
 drivers/scsi/fnic/fnic_trace.c            | 58 +++++++++++++++----------------
 drivers/scsi/gdth_proc.c                  |  2 +-
 drivers/scsi/ipr.c                        |  6 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 ++--
 drivers/scsi/scsi_sysfs.c                 | 10 +++---
 drivers/scsi/smartpqi/smartpqi_init.c     | 22 ++++++------
 8 files changed, 72 insertions(+), 70 deletions(-)

-- 
2.16.4

