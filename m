From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 0/3]  Minor clean up in mpt2sas
Date: Fri, 19 Dec 2014 12:10:08 +0100
Message-ID: <20141219111008.GA17968@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The first patch merges two similar functions. Since the resulting
function is only called three times, it adds a parameter to differenciate
between the two behaviours.

The second patch proposes a simplification of the function code. The function
previously used a variable to skip through the rest of the loop. It now
uses a break statement to exit it.

The third patch simplifies an unnecesary complicated use of a boolean variable.

Quentin Lambert (3):
  [SCSI] mpt2sas: Merge two similar functions
  [SCSI] mpt2sas: Simplify the code of mpt2sas_scsih_tm_flag
  [SCSI] mpt2sas: Remove unnecessary use of a boolean variable

 drivers/scsi/mpt2sas/mpt2sas_base.c  |  6 +----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 48 +++++++-----------------------------
 2 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.9.1
