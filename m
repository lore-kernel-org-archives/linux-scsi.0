From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] iSCSI-target: Fine-tuning for some function
 implementations
Date: Sun, 9 Apr 2017 16:20:22 +0200
Message-ID: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 16:11:23 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use kcalloc() in iscsit_allocate_iovecs()
  Delete error messages for failed memory allocations
  Improve size determinations in four functions

 drivers/target/iscsi/iscsi_target.c | 50 +++++++++++--------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

-- 
2.12.2
