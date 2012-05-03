From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 0/3] qla2xxx target fixes
Date: Thu,  3 May 2012 12:42:57 -0700
Message-ID: <1336074180-20577-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Hi Nic / Arun:

Here are a few pretty major fixes that I hope can get into the 3.5
merge of this stuff (Steve's patch that saves 128MB of memory per port
is maybe not strictly a fix but is pretty major).

Please review / apply.

Thanks!

Roland Dreier (2):
  tcm_qla2xxx: Add hook so qla_target code can shutdown sessions
  qla2xxx: Don't create duplicate target sessions

Steve Hodgson (1):
  tcm_qla2xxx: Convert FC address map from flat array to btree

 drivers/scsi/qla2xxx/Kconfig       |    1 +
 drivers/scsi/qla2xxx/qla_target.c  |   96 ++++++++---------
 drivers/scsi/qla2xxx/qla_target.h  |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  201 ++++++++++++++++--------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   22 +---
 5 files changed, 138 insertions(+), 183 deletions(-)

-- 
1.7.9.5
