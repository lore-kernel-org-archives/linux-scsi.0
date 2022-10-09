Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9C3C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Oct 2022 20:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJIUVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Oct 2022 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJIUVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2022 16:21:40 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9F61C106;
        Sun,  9 Oct 2022 13:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1665346716;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=cQK3SpYyIdHYiU7P71izgMGUHGeEscIPgCldFdgmzdM=;
    b=eIqSCZThyw2v+dsowap2KqOCSKxRwj5pcNMoEcr6QcRhH53bbzXPwisRnO4Y3pUY7H
    Epm0x7ncGUzHhd6rAcr7TdmqrtmnMqD6L4cOy1ER4YIU/5FkuQsLoikzcvuSaezHaDaT
    FlBSMl8EA27YGBIvIZRWr/FLpYuDWxMkaLlXvIVtoiv7hvx1lw7UtcaTidTkAQ4jn3xm
    ttpaqPLLOsBxaqHn6YyGVfkQ1YtR1/l2mMffYxIY4fUYkIkI9TRDmNrIqegEjywosmmO
    eXpcDcHuMOthceOEVH8yH8LuDqF6vuzQyhStKANBVGGGjDE+p73zZi/2jwokI6Ggw6dD
    2T3g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1h3Wv4Xa/LRChhKO/8hvJt7KzgdI0oSHjzSB"
X-RZG-CLASS-ID: mo00
Received: from linux.speedport.ip
    by smtp.strato.de (RZmta 48.1.3 AUTH)
    with ESMTPSA id z90a05y99KIYdXv
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 9 Oct 2022 22:18:34 +0200 (CEST)
From:   Bean Huo <beanhuo@iokpp.de>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] changes for ufshcd.c
Date:   Sun,  9 Oct 2022 22:18:07 +0200
Message-Id: <20221009201809.495207-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

*** BLURB HERE ***

Bean Huo (2):
  scsi: ufs: core: Remove unnecessary if statement
  scsi: ufs: core: Cleanup ufshcd_slave_alloc()

 drivers/ufs/core/ufshcd-priv.h |   3 -
 drivers/ufs/core/ufshcd.c      | 153 ++++++++++++---------------------
 2 files changed, 56 insertions(+), 100 deletions(-)

-- 
2.34.1

