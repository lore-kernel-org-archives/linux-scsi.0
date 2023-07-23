Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523AEC001B0
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 19:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjGWTc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 15:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGWTc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 15:32:56 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Jul 2023 12:32:55 PDT
Received: from mellowmood.mkp.net (mellowmood.mkp.net [104.200.29.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD19094;
        Sun, 23 Jul 2023 12:32:55 -0700 (PDT)
Received: from mellowmood.mkp.net (localhost [127.0.0.1])
        by mellowmood.mkp.net (Postfix) with ESMTP id 7D5D0BA3;
        Sun, 23 Jul 2023 15:12:51 -0400 (EDT)
To:     Udit Kumar <u-kumar1@ti.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <=martin.petersen@oracle.com>, <jejb@linux.ibm.com>, <nm@ti.com>,
        <vigneshr@ti.com>
Subject: Re: [PATCH] scsi: ufs: TI UFS host controller expose device tree
 aliases
From:   "Martin K. Petersen" <=martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz0i787n.fsf@ca-mkp.ca.oracle.com>
References: <20230710094801.183149-1-u-kumar1@ti.com>
Date:   Sun, 23 Jul 2023 15:12:51 -0400
In-Reply-To: <20230710094801.183149-1-u-kumar1@ti.com> (Udit Kumar's message
        of "Mon, 10 Jul 2023 15:18:01 +0530")
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Udit,

> When TI UFS host controller driver is built as kernel module,
> It was not getting auto loaded due to missing aliases in modules.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
