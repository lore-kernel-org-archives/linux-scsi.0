From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/3] hpsa: A few more miscellaneous patches for Jan. 2011
Date: Fri, 07 Jan 2011 10:55:37 -0600
Message-ID: <20110107165247.14259.45944.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

The following series contains a few old fixes that I somehow failed
to send along previously.

---

Stephen M. Cameron (2):
      hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclosure_device()
      hpsa: Fix problem that CMD_UNABORTABLE command status was treated as unknown

Vasiliy Kulikov (1):
      hpsa: avoid leaking stack contents to userland


 drivers/scsi/hpsa.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

-- 
-- steve
