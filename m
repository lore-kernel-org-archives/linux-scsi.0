From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] target/loopback/tcm: Adjustments for some function
 implementations
Date: Mon, 11 Dec 2017 11:40:17 +0100
Message-ID: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 11 Dec 2017 11:33:44 +0100

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Delete an error message for a failed memory allocation in four functions
  Improve a size determination in two functions
  Combine substrings for 26 messages
  Delete two unnecessary variable initialisations in tcm_loop_issue_tmr()
  Delete an unnecessary return statement in tcm_loop_submission_work()
  Use seq_puts() in tcm_loop_show_info()

 drivers/target/loopback/tcm_loop.c | 145 ++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 84 deletions(-)

-- 
2.15.1
