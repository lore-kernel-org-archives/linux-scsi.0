From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] target: Fine-tuning for some function implementations
Date: Sun, 9 Apr 2017 21:43:58 +0200
Message-ID: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 21:33:21 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  rd: Use kcalloc() in two functions
  rd: Delete error messages for failed memory allocations
  rd: Improve size determinations in two functions
  sbc: Use kmalloc_array() in compare_and_write_callback()
  transport: Use kmalloc_array() in transport_kmap_data_sg()

 drivers/target/target_core_rd.c        | 33 +++++++++------------------------
 drivers/target/target_core_sbc.c       |  4 ++--
 drivers/target/target_core_transport.c |  2 +-
 3 files changed, 12 insertions(+), 27 deletions(-)

-- 
2.12.2
