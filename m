From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Fix zero-length regressions in v3.8-rc1 code
Date: Tue, 29 Jan 2013 22:26:12 +0000
Message-ID: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

The following are a handful of zero-length CDB regression bugfixes to address
breakage introduced by the recent sense_reason_t conversion in v3.8-rc1 code,
which incorrectly assumed CHECK_CONDITION status (in all CDB emulation cases)
when NULL was returned by transport_kmap_data_sg().

Please review, as I'd like to get these into v3.8-rc6.

Thank you,

--nab

Nicholas Bellinger (3):
  target: Fix zero-length INQUIRY additional sense code regression
  target: Fix zero-length MODE_SENSE regression
  target: Fix zero-length READ_CAPACITY_16 regression

 drivers/target/target_core_sbc.c |   18 +++++++--------
 drivers/target/target_core_spc.c |   44 +++++++++----------------------------
 2 files changed, 19 insertions(+), 43 deletions(-)

-- 
1.7.2.5
