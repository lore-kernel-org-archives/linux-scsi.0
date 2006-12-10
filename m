From: Olaf Hering <olaf@aepfle.de>
Subject: ibmvscsi compile error in 2.6.20-rc1
Date: Sun, 10 Dec 2006 12:48:03 +0100 (MET)
Message-ID: <20061210114806.GA8687@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p07-ob.rzone.de ([81.169.146.190]:50687 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbWLJLsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Dec 2006 06:48:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org


This happens when client and server are enabled.
And CONFIG_ISERIES is enabled too in my ppc64_defconfig.

  LD      drivers/scsi/ibmvscsi/ibmvscsic.o
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `ibmvscsi_reenable_crq_queue':
rpa_vscsi.c:(.opd+0x0): multiple definition of `ibmvscsi_reenable_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.opd+0x18): first defined here
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `.ibmvscsi_reenable_crq_queue':
rpa_vscsi.c:(.text+0x0): multiple definition of `.ibmvscsi_reenable_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.text+0x8): first defined here
ld: Warning: size of symbol `.ibmvscsi_reenable_crq_queue' changed from 8 in drivers/scsi/ibmvscsi/iseries_vscsi.o to 140 in drivers/scsi/ibmvscsi/rpa_vscsi.o
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `ibmvscsi_reset_crq_queue':
rpa_vscsi.c:(.opd+0x30): multiple definition of `ibmvscsi_reset_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.opd+0x0): first defined here
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `.ibmvscsi_reset_crq_queue':
rpa_vscsi.c:(.text+0x13c): multiple definition of `.ibmvscsi_reset_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.text+0x0): first defined here
ld: Warning: size of symbol `.ibmvscsi_reset_crq_queue' changed from 8 in drivers/scsi/ibmvscsi/iseries_vscsi.o to 236 in drivers/scsi/ibmvscsi/rpa_vscsi.o
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `ibmvscsi_send_crq':
rpa_vscsi.c:(.opd+0x78): multiple definition of `ibmvscsi_send_crq'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.opd+0x30): first defined here
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `.ibmvscsi_send_crq':
rpa_vscsi.c:(.text+0x348): multiple definition of `.ibmvscsi_send_crq'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.text+0x10): first defined here
ld: Warning: size of symbol `.ibmvscsi_send_crq' changed from 216 in drivers/scsi/ibmvscsi/iseries_vscsi.o to 68 in drivers/scsi/ibmvscsi/rpa_vscsi.o
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `ibmvscsi_init_crq_queue':
rpa_vscsi.c:(.opd+0xa8): multiple definition of `ibmvscsi_init_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.opd+0x60): first defined here
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `.ibmvscsi_init_crq_queue':
rpa_vscsi.c:(.text+0x440): multiple definition of `.ibmvscsi_init_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.text+0x140): first defined here
ld: Warning: size of symbol `.ibmvscsi_init_crq_queue' changed from 188 in drivers/scsi/ibmvscsi/iseries_vscsi.o to 728 in drivers/scsi/ibmvscsi/rpa_vscsi.o
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `ibmvscsi_release_crq_queue':
rpa_vscsi.c:(.opd+0xc0): multiple definition of `ibmvscsi_release_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.opd+0x48): first defined here
drivers/scsi/ibmvscsi/rpa_vscsi.o: In function `.ibmvscsi_release_crq_queue':
rpa_vscsi.c:(.text+0x718): multiple definition of `.ibmvscsi_release_crq_queue'
drivers/scsi/ibmvscsi/iseries_vscsi.o:iseries_vscsi.c:(.text+0xe8): first defined here
ld: Warning: size of symbol `.ibmvscsi_release_crq_queue' changed from 88 in drivers/scsi/ibmvscsi/iseries_vscsi.o to 236 in drivers/scsi/ibmvscsi/rpa_vscsi.o
make[4]: *** [drivers/scsi/ibmvscsi/ibmvscsic.o] Error 1

