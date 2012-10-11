From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 0/2] qla2xxx target fixes
Date: Thu, 11 Oct 2012 13:41:30 -0700
Message-ID: <1349988092-27640-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Hi everyone, a couple of qla2xxx target fixes that we've been shipping
for a while at Pure and that I've finally got around to cleaning up
and merging to the latest kernel tree...

Roland Dreier (2):
  tcm_qla2xxx: Format VPD page 83h SCSI name string according to SPC
  qla2xxx: Update target lookup session tables when a target session
    changes

 drivers/scsi/qla2xxx/qla_target.c  |   22 +++++------
 drivers/scsi/qla2xxx/qla_target.h  |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   77 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 +
 4 files changed, 89 insertions(+), 13 deletions(-)

-- 
1.7.10.4
