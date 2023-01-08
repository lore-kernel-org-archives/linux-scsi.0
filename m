Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18D3C54EBC
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 22:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjAHWlR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 17:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjAHWlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 17:41:15 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAA2F58A;
        Sun,  8 Jan 2023 14:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1673217670;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=f16eun26LqjQiVPkfU+1B6k/v64vZBOWJYXVU/5iBzc=;
    b=Wkv2DjaDALvsJWnsQ8U71alglK4S2WOD6ForyqaLmTL3cGonUixvePG2qOS0ieupIx
    MYDlrrFlWNLecCdf6SvUSy3ZVwJEE4kVQ9unwyPSwliZCGCTg1vlM6BzlBkbQPpCAXJ6
    5PZ84xw2IKOez/+LI00xqLPe16rPppg0B9x1rI1uK94EzWpKUkGNOFT5nXs6qOOE2GXn
    +jO31jVaO/Ynj4NwwTqwBlYiej/CXvNulhKxChzsIo6UX0o543KYha+5F9X1R4fiX8/A
    pnvfa040zuHRPMLtqLEE6n/a3drumGIcr32u5bV8pndmdV0mT0d1AD9/jnKVC0lUjafg
    sgUg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1UnWvo/SqbTSXcQZxAZvLxWc5msS6txu0oUh"
X-RZG-CLASS-ID: mo00
Received: from blinux.speedport.ip
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id 905423z08Mf8Ae8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 8 Jan 2023 23:41:08 +0100 (CET)
From:   Bean Huo <beanhuo@iokpp.de>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        quic_cang@quicinc.com, quic_xiaosenh@quicinc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@iokpp.de>
Subject: [PATCH v2 0/3] Several compilation warnings fixes for UFS Advanced RPMB
Date:   Sun,  8 Jan 2023 23:40:54 +0100
Message-Id: <20230108224057.354438-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

These patches are to fix several compilation warnings introduced by my commit:
6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg"),
please consider this patch series for the next your merge window.
Apologies for this!!



Changelog:

V1--V2:
    1. Add new patches 2/3 and 3/3.


Bean Huo (3):
  scsi: ufs: core: bsg: Fix sometimes-uninitialized warnings
  scsi: core: Fix invisible definition compilation warning
  scsi: ufs: core: bsg: Fix cast to restricted __be16 warning

 drivers/ufs/core/ufs_bsg.c       |  4 ++--
 include/uapi/scsi/scsi_bsg_ufs.h | 12 ++++++------
 include/ufs/ufshcd.h             |  1 +
 3 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.25.1

