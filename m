Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,
	BODY_QUOTE_MALF_MSGID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DE6C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881992072E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgG0T6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:58:24 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:34633 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgG0T6Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:58:24 -0400
IronPort-SDR: yDQpsgaBsM24foIdck0Sb9XLYjQEZPTdjn8Qjkz8A8bSlc4hLKPW3ZgzMJU2wVzmFna88xQ44n
 jJUbgLT83Paq9akvfQAzFS5pDfeaHtbZauecoscaWSdPLPAyMqaK/NXn8IVCmfW0kIxpCQsVYd
 P1DTmrtwIejq2ptRzghHIKsHrE60XDZwSHv/BhSrpK6zyKFjkqHG+i7dH2duUomnC+HV/Bed8D
 aSsdHIuCOfPipKBLJkPqiHHMyl+hqXDTKYMzlo4Lc+etcrXdq6EFPul5p7BT+F6K/pw8OEVRwx
 ltk=
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="85550538"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 12:58:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 12:58:21 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 27 Jul 2020 12:58:21 -0700
Subject: [PATCH V3 0/4] hpsa updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 27 Jul 2020 14:58:22 -0500
Message-ID: <159587987792.28270.15427178888235104199.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
hpsa-correct-rare-oob-condition
 - Rare condition where a spare is first in
   PHYS LUN list.
hpsa-increase-qd-for-external-luns
 - Improve performance for PTRAID devices
   - Such as MSA devices.
hpsa-increase-ctlr-eh-timeout
 - Increase timeout for commands issued to
   controller device.
 - Improve multipath failover handling.
hpsa-bump-version

Changes since V1:
 - corrected uninitialized variable issue in
   hpsa-slave-destroy in patch:
        hpsa-increase-ctlr-eh-timeout
   Reported by: Dan Carpenter <dan.carpenter@oracle.com>
   Reported by: Joseph Szczypek <jszczype@redhat.com>

Changes since V2:
 - Forgot to add the version number to the
   patches.

---

Don Brace (4):
      hpsa: correct rare oob condition
      hpsa: increase qd for external luns
      hpsa: increase ctlr eh timeout
      hpsa: bump version


 drivers/scsi/hpsa.c | 15 ++++++++++-----
 drivers/scsi/hpsa.h |  2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

--
Signature
