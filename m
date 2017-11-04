From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] target: Adjustments for four function implementations
Date: Sat, 4 Nov 2017 14:14:07 +0100
Message-ID: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Nov 2017 14:09:09 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Use common error handling code in three functions
  Combine two condition checks into one statement in target_xcopy_do_work()
  Improve a size determination in three functions
  Delete an error message for a failed memory allocation in two functions

 drivers/target/target_core_xcopy.c | 69 ++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

-- 
2.15.0
