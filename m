Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE6FC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 13:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjDYNAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDYNAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 09:00:20 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C519A5;
        Tue, 25 Apr 2023 06:00:18 -0700 (PDT)
Received: from user-virtual-machine.. ([10.12.182.5])
        (user=jinhongzhu@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33PCwNUe032171-33PCwNUf032171
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 25 Apr 2023 20:58:36 +0800
From:   Jinhong Zhu <jinhongzhu@hust.edu.cn>
To:     martin.petersen@oracle.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, error27@gmail.com,
        jejb@linux.ibm.com, jhasan@marvell.com, jinhongzhu@hust.edu.cn,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        skashyap@marvell.com
Subject: Re: Re: [PATCH] qedf: Fix NULL dereference in error handling
Date:   Tue, 25 Apr 2023 20:58:23 +0800
Message-Id: <20230425125823.2325-1-jinhongzhu@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <yq1fs8ok4v9.fsf@ca-mkp.ca.oracle.com>
References: <yq1fs8ok4v9.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: jinhongzhu@hust.edu.cn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> Fixes: 09e062ce83cb ("qedf: Fix NULL dereference in error handling")

>This commit does not appear to exist in Linus' tree.

Sorry for the wrong fixes tag.

This is the correct one.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")

regards,
jinhong zhu
