From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 00/20] [SCSI] remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 09:54:11 +0900
Message-ID: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23114 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IWAyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 20:54:18 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTJ00393ZU33C70@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 09:54:12 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound),
the driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

---
 drivers/scsi/arcmsr/arcmsr_hba.c          |    1 -
 drivers/scsi/atp870u.c                    |    2 --
 drivers/scsi/bfa/bfad.c                   |    1 -
 drivers/scsi/csiostor/csio_init.c         |    2 --
 drivers/scsi/dc395x.c                     |    1 -
 drivers/scsi/fnic/fnic_main.c             |    1 -
 drivers/scsi/gdth.c                       |    2 --
 drivers/scsi/hpsa.c                       |    1 -
 drivers/scsi/lpfc/lpfc_init.c             |    3 ---
 drivers/scsi/megaraid/megaraid_mbox.c     |    6 ------
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 -----
 drivers/scsi/mvsas/mv_init.c              |    1 -
 drivers/scsi/mvumi.c                      |    2 --
 drivers/scsi/pm8001/pm8001_init.c         |    1 -
 drivers/scsi/pmcraid.c                    |    1 -
 drivers/scsi/qla2xxx/qla_os.c             |    1 -
 drivers/scsi/qla4xxx/ql4_os.c             |    1 -
 drivers/scsi/stex.c                       |    2 --
 drivers/scsi/tmscsim.c                    |    1 -
 drivers/scsi/ufs/ufshcd-pci.c             |    1 -
 drivers/scsi/vmw_pvscsi.c                 |    2 --
 21 files changed, 38 deletions(-)

