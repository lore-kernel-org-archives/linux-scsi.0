From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [0/3] add MODULE_VERSION to drivers/scsi
Date: Wed, 21 Jul 2004 17:01:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040721220111.GA16608@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:44121 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266592AbUGUWCQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2004 18:02:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jgarzik@pobox.com

James, please do a

	bk pull http://mdomsch.bkbits.net/linux-2.6-modversions

This will update the following files:

 drivers/scsi/aacraid/linit.c           |    1 
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    5 ---
 drivers/scsi/aic7xxx/aic7xxx_osm.c     |    5 ---
 drivers/scsi/aic7xxx_old.c             |    1 
 drivers/scsi/ata_piix.c                |    1 
 drivers/scsi/libata-core.c             |    1 
 drivers/scsi/megaraid.c                |    3 +
 drivers/scsi/qla1280.c                 |    1 
 drivers/scsi/qla2xxx/ql2100.c          |    1 
 drivers/scsi/qla2xxx/ql2200.c          |    1 
 drivers/scsi/qla2xxx/ql2300.c          |    1 
 drivers/scsi/qla2xxx/ql2322.c          |    1 
 drivers/scsi/qla2xxx/ql6312.c          |    1 
 drivers/scsi/qla2xxx/ql6322.c          |    1 
 drivers/scsi/qla2xxx/qla_os.c          |    1 
 drivers/scsi/sata_nv.c                 |    1 
 drivers/scsi/sata_promise.c            |    1 
 drivers/scsi/sata_sil.c                |    1 
 drivers/scsi/sata_sis.c                |    1 
 drivers/scsi/sata_svw.c                |    1 
 drivers/scsi/sata_sx4.c                |    1 
 drivers/scsi/sata_via.c                |    1 
 drivers/scsi/sata_vsc.c                |    1 
 drivers/scsi/sym53c8xx_2/sym_glue.c    |    2 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c    |    5 ---
 drivers/scsi/sym53c8xx_2/sym_version.h |   53 +++++++++++++++++++++++++++++++++
 26 files changed, 81 insertions, 12 deletions

through these ChangeSets:

<Matt_Domsch@dell.com> (04/07/19 1.1842.1.3)
   Set MODULE_VERSION
   
   Move SYM_VERSION and SYM_DRIVER_NAME to new sym_version.h file

<Matt_Domsch@dell.com> (04/07/19 1.1842.1.2)
   Set MODULE_VERSION for drivers/scsi
   
   for Adaptec SCSI, megaraid qla1280, qla2x00

<Matt_Domsch@dell.com> (04/07/19 1.1842.1.1)
   Set MODULE_VERSION for drivers/scsi/ SATA, libata, and ata_piix.



Patches will follow as separate mails.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
