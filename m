From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 0/3] zfcp: timer_setup() refactoring feature for v4.15-rc1
Date: Wed,  8 Nov 2017 15:17:06 +0100
Message-ID: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

here is a small series for the timer_setup() refactoring of zfcp.
We target it for the merge window to land in v4.15-rc1.

Unfortunately, they don't seem to apply to the current state of neither
James' misc branch nor Martin's 4.15/scsi-queue branch,
because they depend on:
v4.14-rc3 686fef928bba ("timer: Prepare to change timer callback argument type")
and
v4.14-rc7 ab31fd0ce65e ("scsi: zfcp: fix erp_action use-before-initialize in REC action trace").

However, they do apply to Linus' tree for v4.14-rc7 or later and
thus they would also apply for the upcoming merge window.

In http://www.spinics.net/lists/linux-scsi/msg114581.html I saw a decision
to have such changes go in via the timer tree. I would be happy with that.

Kees Cook (1):
  zfcp: convert timers to use timer_setup()

Steffen Maier (2):
  zfcp: purely mechanical update using timer API, plus blank lines
  zfcp: drop open coded assignments of timer_list.function

 drivers/s390/scsi/zfcp_erp.c | 15 +++++++++------
 drivers/s390/scsi/zfcp_ext.h |  2 +-
 drivers/s390/scsi/zfcp_fsf.c | 13 ++++++-------
 3 files changed, 16 insertions(+), 14 deletions(-)

-- 
2.13.5
