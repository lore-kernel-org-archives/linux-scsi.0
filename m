From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: [PATCH v2 0/3] scsi: ufs: typo fixes and improvement
Date: Sun, 23 Jun 2019 17:37:56 +0000
Message-ID: <BN7PR08MB5684A44F56972BCE0972B28EDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Bean Huo (beanhuo)" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org


From: Bean Huo <beanhuo@micron.com>

This series patch is to fix several typos and fix one issue of twice
completing ufs-bsg job in case of UPIU/DME command failed.

Changed since v1:
    - split v1 patch
    - add fixes tag
    - delete needless blank line

Bean Huo (3):
  scsi: ufs: fix typos in comment of ufshcd_uic_change_pwr_mode
  scsi: ufs-bsg: fix typo in ufs_bsg_request
  scsi: ufs-bsg: complete ufs-bsg job only if no error

 drivers/scsi/ufs/ufs_bsg.c | 6 ++++--
 drivers/scsi/ufs/ufshcd.c  | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--=20
2.7.4
