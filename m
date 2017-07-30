From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 00/29] constify scsi pci_device_id.
Date: Sun, 30 Jul 2017 14:07:09 +0530
Message-ID: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Arvind Yadav (29):
  [PATCH 01/29] scsi: qla1280: constify pci_device_id.
  [PATCH 02/29] scsi: qedi: constify pci_device_id.
  [PATCH 03/29] scsi: am53c974: constify pci_device_id.
  [PATCH 04/29] scsi: pm8001: constify pci_device_id.
  [PATCH 05/29] scsi: qla4xxx: constify pci_device_id.
  [PATCH 06/29] scsi: mvsas: constify pci_device_id.
  [PATCH 07/29] scsi: 3w-9xxx: constify pci_device_id.
  [PATCH 08/29] scsi: ipr: constify pci_device_id.
  [PATCH 09/29] scsi: arcmsr: constify pci_device_id.
  [PATCH 10/29] scsi: dpt_i2o: constify pci_device_id.
  [PATCH 11/29] scsi: 3w-sas: constify pci_device_id.
  [PATCH 12/29] scsi: hptiop: constify pci_device_id.
  [PATCH 13/29] scsi: fdomain: constify pci_device_id.
  [PATCH 14/29] scsi: snic: constify pci_device_id.
  [PATCH 15/29] scsi: sym53c8xx_2: constify pci_device_id.
  [PATCH 16/29] scsi: esas2r: constify pci_device_id.
  [PATCH 17/29] scsi: qla2xxx: constify pci_device_id.
  [PATCH 18/29] scsi: dmx3191d: constify pci_device_id.
  [PATCH 19/29] scsi: megaraid: constify pci_device_id.
  [PATCH 20/29] scsi: cxlflash: constify pci_device_id.
  [PATCH 21/29] scsi: nsp32: constify pci_device_id.
  [PATCH 22/29] scsi: pmcraid: constify pci_device_id.
  [PATCH 23/29] scsi: fnic: constify pci_device_id.
  [PATCH 24/29] scsi: stex: constify pci_device_id.
  [PATCH 25/29] scsi: megaraid: constify pci_device_id.
  [PATCH 26/29] scsi: a100u2w: constify pci_device_id.
  [PATCH 27/29] scsi: advansys: constify pci_device_id.
  [PATCH 28/29] scsi: atp870u: constify pci_device_id.
  [PATCH 29/29] scsi: 3w-xxxx: constify pci_device_id.

 drivers/scsi/3w-9xxx.c                    | 2 +-
 drivers/scsi/3w-sas.c                     | 2 +-
 drivers/scsi/3w-xxxx.c                    | 2 +-
 drivers/scsi/a100u2w.c                    | 2 +-
 drivers/scsi/advansys.c                   | 2 +-
 drivers/scsi/am53c974.c                   | 2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          | 2 +-
 drivers/scsi/atp870u.c                    | 2 +-
 drivers/scsi/cxlflash/main.c              | 2 +-
 drivers/scsi/dmx3191d.c                   | 2 +-
 drivers/scsi/dpt_i2o.c                    | 2 +-
 drivers/scsi/esas2r/esas2r_main.c         | 2 +-
 drivers/scsi/fdomain.c                    | 2 +-
 drivers/scsi/fnic/fnic_main.c             | 2 +-
 drivers/scsi/hptiop.c                     | 2 +-
 drivers/scsi/ipr.c                        | 2 +-
 drivers/scsi/megaraid.c                   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 drivers/scsi/mvsas/mv_init.c              | 2 +-
 drivers/scsi/nsp32.c                      | 2 +-
 drivers/scsi/pm8001/pm8001_init.c         | 2 +-
 drivers/scsi/pmcraid.c                    | 2 +-
 drivers/scsi/qedi/qedi_main.c             | 2 +-
 drivers/scsi/qla1280.c                    | 2 +-
 drivers/scsi/qla2xxx/qla_os.c             | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c             | 2 +-
 drivers/scsi/snic/snic_main.c             | 2 +-
 drivers/scsi/stex.c                       | 2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 2 +-
 29 files changed, 29 insertions(+), 29 deletions(-)

-- 
2.7.4
