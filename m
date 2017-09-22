From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 0/5] use setup_timer() helper function.
Date: Fri, 22 Sep 2017 15:38:49 +0530
Message-ID: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This series uses setup_timer() helper function. The series
addresses the files under drivers/target/iscsi/*.

Allen Pais (5):
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.

 drivers/target/iscsi/iscsi_target_erl0.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_erl1.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_login.c | 5 ++---
 drivers/target/iscsi/iscsi_target_nego.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_util.c  | 5 ++---
 5 files changed, 10 insertions(+), 15 deletions(-)

-- 
2.7.4
