From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] SCSI-QLA4...: Deletion of some unnecessary checks
Date: Fri, 06 Feb 2015 23:10:44 +0100
Message-ID: <54D53BE4.7010807@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E. J. Bottomley" <JBottomley@parallels.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 6 Feb 2015 23:03:41 +0100

Further update suggestions were taken into account after a patch was applied
from static source code analysis.

Markus Elfring (4):
  Deletion of unnecessary checks before three function calls
  Less function calls in qla4xxx_is_session_exists() after error detection
  Less function calls in qla4xxx_is_flash_ddb_exists() after error detection
  Less function calls in qla4xxx_sysfs_ddb_logout() after error detection

 drivers/scsi/qla4xxx/ql4_mbx.c |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c  | 96 ++++++++++++++++++------------------------
 2 files changed, 42 insertions(+), 56 deletions(-)

-- 
2.2.2
