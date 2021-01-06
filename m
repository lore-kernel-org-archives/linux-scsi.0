Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A13C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D94E623132
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbhAFVly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbhAFVly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Jan 2021 16:41:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDE5623132;
        Wed,  6 Jan 2021 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609969274;
        bh=b1FxHFkUPh54WkIcPoJWopFP82NTDeE+9rWNRhcqFfc=;
        h=From:To:Cc:Subject:Date:From;
        b=eizqZ9+erRWKJG0Qv8IfgjmJgKZ0DoWh3YqMSOe3E90SVTCYCt2axe1H5FMwKFEFq
         z+npYon2nxRAk//pYp3k9GFrk69mX3GP894GZ6qh6A7aC8God24gP5gjZcxvgphePI
         qC3d71iJ9RPghMv/IhrE8XxRjTdLXmai3mtmHRX6tbDusPnuTHfCViEuWGteChYixV
         2w7txZXCNUXLxBJ41qy02VPqb5yUfy5gW/FD0eX09I3QjaAKnUq9wfjamflt+7y1ss
         yr1zSiGFiyccgpu+l0qBthAmF+lqHKOXKSM+7k2Ci50Or2t/ss+jsKx8L8DMu9cvur
         H1TX2LfzVadhA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com
Subject: [PATH v3 0/2] Two UFS bug fixes
Date:   Wed,  6 Jan 2021 13:41:07 -0800
Message-Id: <20210106214109.44041-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change log from v2:
 - fix build warning


