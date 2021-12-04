Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165A9C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354448AbhLDAaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbhLDAaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:15 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3DCC061751
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:51 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s37so4606365pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoEWkYbcqxSeDDgp2T0SY6Mzm/gsCeWqgEBZpLWYS+0=;
        b=EJhmKfAKP/UiCxzy1enddmz0mBsAAryBdHq6o0GRHaoUeyD3/exjbIzHlrD+013kqN
         mcGcS/02TgBM2RmRPOJ24Cn6ptxlagJ/kDtxMdLHDmiAxn5mCj40zW5QFT+5cEKzDJ2f
         JRMjPYUMZNLTCBuGc8PgbQvcU5Y7JEjM+z5qcLifkHrzI6TDo4QVi4NLGZD4pwHqQLaE
         BQMhS9XcuyOpVbNZhOv+iFXO6kI2nF9Mog0cvhdkGMKhy1ax2QxhkSNkFyQLAr70eJKH
         NVj+ofGJYEUtYe3dCSomGlw1aKwneLigU88opv/2Bb7qtU9ClJRn6OsP+ajaJRPTAU5j
         EJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KoEWkYbcqxSeDDgp2T0SY6Mzm/gsCeWqgEBZpLWYS+0=;
        b=zNWLjgtY0yQHRK3mUL4sewm3KSIWCxkVwzSyv+Dqwl+Lh2p+aqBn8edUPbBDrZcPO1
         +uLauNCSxc6UsOL+WY94d8r6+ycsOvblsKVtkfCXamcI8nRqPdcz3Etkg+z2nhrx+Auw
         94nbDDXNj0Rl2+HhfXUHaSc13g2toWKHgWL/vfY1hLCxXgG+bel3FyIKi89LXMz24yob
         sJU9PjY2N0kbuMmf2yhryErPpoV2zI84qIkP2zkrgIQbvqiPuM76wfKzp/VFIRb0aCYK
         WpseZkCq/0+xOlGDW+eFo4z/vpW/5JElLc7TXpPie2wqTQ2hBVSUtD5LWSxrgwY6RKtY
         85Uw==
X-Gm-Message-State: AOAM53271DQmSYlT9AITEKiP3uh5yZti1XqQZqeFgkgByCbr3nm6BcAN
        Qdqvg1MuYhOR0sAc0OQ/qO3jg8mvKgw=
X-Google-Smtp-Source: ABdhPJz80Z/ddWA3cjFlOQocsfp7Bi4O2bwA5I5oDZfvNlaILEK2wL85ltcJTM1pJa8fN2g18z4cPA==
X-Received: by 2002:a63:894a:: with SMTP id v71mr7042317pgd.421.1638577610511;
        Fri, 03 Dec 2021 16:26:50 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:50 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/9] lpfc: Update lpfc to revision 14.0.0.4
Date:   Fri,  3 Dec 2021 16:26:35 -0800
Message-Id: <20211204002644.116455-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.4

This patch set contains several bug fixes.

The patches were cut against Martin's 5.16/scsi-fixes tree

James Smart (9):
  lpfc: Fix leaked lpfc_dmabuf mbox allocations with npiv
  lpfc: Change return code on ios received during link bounce
  lpfc: Fix lpfc_force_rscn ndlp kref imbalance
  lpfc: Fix NPIV port deletion crash
  lpfc: Trigger SLI4 firmware dump before doing driver cleanup
  lpfc: Adjust CMF total bytes and rxmonitor
  lpfc: Cap CMF read bytes to MBPI
  lpfc: Add additional debugfs support for CMF
  lpfc: Update lpfc version to 14.0.0.4

 drivers/scsi/lpfc/lpfc.h           |  7 ++-
 drivers/scsi/lpfc/lpfc_attr.c      | 62 ++++++++++++++--------
 drivers/scsi/lpfc/lpfc_debugfs.c   | 27 +++++++---
 drivers/scsi/lpfc/lpfc_debugfs.h   |  2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 22 +++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 10 ++--
 drivers/scsi/lpfc/lpfc_hw.h        |  2 +-
 drivers/scsi/lpfc/lpfc_init.c      | 37 +++++++++----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  6 +++
 drivers/scsi/lpfc/lpfc_scsi.c      |  8 +--
 drivers/scsi/lpfc/lpfc_sli.c       |  6 ---
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 drivers/scsi/lpfc/lpfc_vport.c     | 83 +++++++++++++++++++++++-------
 13 files changed, 189 insertions(+), 85 deletions(-)

-- 
2.26.2

