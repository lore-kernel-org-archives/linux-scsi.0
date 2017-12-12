From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/8] target-iSCSI: Adjustments for several function
 implementations
Date: Tue, 12 Dec 2017 22:40:05 +0100
Message-ID: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 22:22:11 +0100

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (8):
  Less function calls in chap_server_compute_md5() after error detection
  Move resetting of seven variables in chap_server_compute_md5()
  Delete 36 error messages for a failed memory allocation
  Delete an unnecessary variable initialisation in iscsit_allocate_ooo_cmdsn()
  Delete an unnecessary variable initialisation in iscsi_copy_param_list()
  Delete an unnecessary variable initialisation in iscsi_create_default_params()
  Delete an unnecessary variable initialisation in iscsi_set_default_param()
  Improve 16 size determinations

 drivers/target/iscsi/iscsi_target.c               |   2 -
 drivers/target/iscsi/iscsi_target_auth.c          | 110 +++++++++++-----------
 drivers/target/iscsi/iscsi_target_datain_values.c |   6 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |  14 +--
 drivers/target/iscsi/iscsi_target_erl2.c          |   8 +-
 drivers/target/iscsi/iscsi_target_login.c         |  29 ++----
 drivers/target/iscsi/iscsi_target_nego.c          |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |  58 +++++-------
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  34 +++----
 drivers/target/iscsi/iscsi_target_tpg.c           |  13 +--
 drivers/target/iscsi/iscsi_target_util.c          |  11 +--
 11 files changed, 118 insertions(+), 171 deletions(-)

-- 
2.15.1

