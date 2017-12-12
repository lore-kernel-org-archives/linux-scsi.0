From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] target/iscsi/cxgbit: Adjustments for seven function
 implementations
Date: Tue, 12 Dec 2017 13:20:05 +0100
Message-ID: <77d06f1c-a650-644f-7364-55bb52aeb6ac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Johannes Berg <johannes.berg@intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 13:12:11 +0100

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in two functions
  Combine substrings for 11 messages

 drivers/target/iscsi/cxgbit/cxgbit_target.c | 58 +++++++++--------------------
 1 file changed, 18 insertions(+), 40 deletions(-)

-- 
2.15.1
