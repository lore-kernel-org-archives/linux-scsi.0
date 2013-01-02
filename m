From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 0/5] target task management fixes and cleanups
Date: Wed,  2 Jan 2013 12:47:56 -0800
Message-ID: <1357159681-24477-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Hi Nic,

A few fixes for TMR handling (fix crashes when a backend is really
slow, fix a reference leak if we get a TMR for a non-existent LUN) and
a couple of trivial cleanups in related code.

Roland Dreier (5):
  target: Don't let abort handling free pending write commands too soon
  target: Fix use-after-free in LUN RESET handling
  target: Release se_cmd when LUN lookup fails for TMR
  target: Remove useless if statement
  target: Remove never-used TMR_FABRIC_TMR enum value

 drivers/target/target_core_tmr.c       | 12 ------------
 drivers/target/target_core_transport.c |  8 +++++---
 include/target/target_core_base.h      |  1 -
 3 files changed, 5 insertions(+), 16 deletions(-)

-- 
1.8.0
