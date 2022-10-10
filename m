Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D3CC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Oct 2022 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiJJJaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Oct 2022 05:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiJJJaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2022 05:30:03 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06AA1177;
        Mon, 10 Oct 2022 02:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1665394188;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=atGmaLDd1IIC9YR0qLClomH8kGnJ1e+JxBrxwY5UVbM=;
    b=m/2CjXeR6DQxG4J/WfUBUBgsESc8Cg7BAs/UBUt+Z9esWHLAmrezjJ0QARjZIUQBwC
    F8iWPbbkwhucMQP/hKNQ7633ykaK19uMM4KcfBv7aRHIllXcdPEOFYJa2W0wooSyQL4p
    /fJWeT+/UDv2AuMUWub45bIgaHtgAOVcNtN295c2CZU+0vRwNWm1B0DY6umbC7Szaln+
    u3ZLAfAbhia1UMhVCz4AW0DNOUk7/JSG12z4bn9HXAwxVS+FOlhcXfc0ltB0gMnxSyLp
    YWIYIhplhK74lo6CEzCXNFAQtziwo2mUgUK29CqoRS/A+Nzz90k5RVxkkyXmR74z4v/Q
    +hTA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD2QzemV2tdlNlNRZBXiUw="
X-RZG-CLASS-ID: mo00
Received: from linux.micron.com
    by smtp.strato.de (RZmta 48.2.0 AUTH)
    with ESMTPSA id zad98cy9A9Tk0DA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 10 Oct 2022 11:29:46 +0200 (CEST)
From:   Bean Huo <beanhuo@iokpp.de>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Changes for ufshcd.c
Date:   Mon, 10 Oct 2022 11:29:35 +0200
Message-Id: <20221010092937.520013-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

v1--v2:
    1. change in ufshcd_lu_init() in  patch 2/2:
        1) Remove duplicate parameter initialization
        2) Move lun parameter initialization before kmalloc()

Bean Huo (2):
  scsi: ufs: core: Remove unnecessary if statement
  scsi: ufs: core: Cleanup ufshcd_slave_alloc()

 drivers/ufs/core/ufshcd-priv.h |   3 -
 drivers/ufs/core/ufshcd.c      | 151 ++++++++++++---------------------
 2 files changed, 54 insertions(+), 100 deletions(-)

-- 
2.34.1

