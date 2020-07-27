Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,
	BODY_QUOTE_MALF_MSGID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B312C433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA27820719
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 19:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgG0TBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:01:12 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:40725 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgG0TBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 15:01:12 -0400
IronPort-SDR: YU7egFHY6erwtdOyK58GrlyIx3xP0ftKRwnJwdzdprLy5XG5BH0h3ZVDDLORHnCmwfVLZ2P/cJ
 k4ODoxDKC7+RA81EYXKT08Ik1AB0i7pOKLnwRhS6szsOXTvtgVtxOI1KjH7+OqaKp1b6mBEHZB
 /YZxHvyJpUWBux6xcKNvBAOdlijvaFu984rJq0LuEgnNOabZC0k99FD3CI/eZNkoYUYjyfNcd7
 MU06ep3xB9V553zLCENjdX3JoZsUF1LMmzGIqfaWlUCGrw+HvfFRiQcgZIUVEvfwzWrFryK9XO
 +fs=
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="81443269"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jul 2020 12:01:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 12:01:00 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 27 Jul 2020 12:01:00 -0700
Subject: [PATCH V2 0/4] hpsa updates
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 27 Jul 2020 14:01:00 -0500
Message-ID: <159587636236.27787.16970342225988726638.stgit@brunhilda>
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
