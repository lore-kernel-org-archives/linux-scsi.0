From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] block: Deletion of checks before three function calls
Date: Sun, 18 Jan 2015 15:31:07 +0100
Message-ID: <54BBC3AB.6040207@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 14:50:06 +0100

Functions which release a system resource are occasionally documented in the way
that they tolerate the passing of a null pointer for example. I do not see a need
because of this fact that a function caller repeats a corresponding check.

Markus Elfring (3):
  cciss: Deletion of an unnecessary check before the function call "put_disk"
  z2ram: Delete an unnecessary check before the function call "kfree"
  Deletion of checks before the function call "iounmap"

 drivers/block/cciss.c    | 18 ++++++------------
 drivers/block/mg_disk.c  |  3 +--
 drivers/block/skd_main.c |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

-- 
2.2.2
