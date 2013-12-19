From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] Handle data underflow
Date: Thu, 19 Dec 2013 14:36:10 +0100
Message-ID: <1387460172-27396-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Here are some minor cleanups to better handler data underflow in
target_emulate_report_referrals and during VPD emulation.

The first is on request from Nic, and the second resolves a
high stack frame usage during generating INQUIRY responses.

Hannes Reinecke (2):
  target_core_alua: check for buffer overflow
  target_core_spc: bounds check for spc_emulate_inquiry()

 drivers/target/target_core_alua.c    |  23 ++-
 drivers/target/target_core_spc.c     | 391 +++++++++++++++++++++--------------
 include/target/target_core_backend.h |   2 +-
 3 files changed, 252 insertions(+), 164 deletions(-)

-- 
1.7.12.4
