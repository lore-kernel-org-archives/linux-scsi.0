From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH] scsi: ufs: sysfs: reworking of the rpm_lvl and spm_lvl entries
Date: Thu,  1 Mar 2018 12:48:05 +0200
Message-ID: <1519901286-17496-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, subhashj@codeaurora.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

The functions related to the rpm_lvl and spm_lvl sysfs entries were moved to
a separate file as part of UFS device management patchset. During the review
phase I was pointed that these entries implementaion could be improved.
The each file output was split to three parts:
    rmp_lvl - rpm_lvl, rpm_target_dev_state, rpm_target_link_state
    smp_lvl - spm_lvl, spm_target_dev_state, spm_target_link_state.
Each new entry has a single value output and doesn't reqire additional 
parsing.
The information about new entries and possible power management levels was
added to the corresponding ABI file.
The on-write behaviour of these entries wasn't changed.

Stanislav Nijnikov (1):
  scsi: ufs: sysfs: reworking of the rpm_lvl and spm_lvl entries

 Documentation/ABI/testing/sysfs-driver-ufs | 67 ++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 92 +++++++++++++++---------------
 2 files changed, 114 insertions(+), 45 deletions(-)

-- 
2.7.4
