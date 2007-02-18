From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] final SCSI updates for 2.6.20
Date: Sun, 18 Feb 2007 09:05:08 -0600
Message-ID: <1171811108.3423.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56217 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751265AbXBRPFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Feb 2007 10:05:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

These represent the final updates, after which we'll move over into
separated fixes for post 2.6.21 and bug fixes for rc candidates mode.
The patches are available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Stern (3):
       SCSI core: better initialization for sdev->scsi_level
       scsi_proc.c: display sdev->scsi_level correctly
       scsi_scan.c: handle bad inquiry responses

FUJITA Tomonori (1):
       tgt: fix the user/kernel ring buffer interface

James Bottomley (1):
       aic94xx: tie driver to the major number of the sequencer firmware

Linas Vepstas (1):
       lpfc: add PCI error recovery support

peter fuerst (2):
       sgiwd93: interfacing to wd33c93
       wd33c93: Fast SCSI with WD33C93B

Richard Knutsson (1):
       megaraid: pci_module_init to pci_register_driver

Rolf Eike Beer (2):
       scsi_transport.h should include scsi_device.h
       aic79xx: remove extra newline from info message

Sumant Patro (5):
       megaraid_sas: update version and author info
       megaraid_sas: return sync cache call with success
       megaraid_sas: replace pci_alloc_consitent with dma_alloc_coherent in ioctl path
       megaraid_sas: add bios_param in scsi_host_template
       megaraid_sas: do not process cmds if hw_crit_error is set

and the diffstat

 drivers/scsi/aic7xxx/aic79xx_osm.c   |    1 
 drivers/scsi/aic94xx/aic94xx_seq.c   |   13 +
 drivers/scsi/aic94xx/aic94xx_seq.h   |    1 
 drivers/scsi/lpfc/lpfc_init.c        |   97 ++++++++++
 drivers/scsi/lpfc/lpfc_sli.c         |   12 +
 drivers/scsi/megaraid.c              |    2 
 drivers/scsi/megaraid/megaraid_sas.c |   90 ++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    6 
 drivers/scsi/scsi_proc.c             |    5 
 drivers/scsi/scsi_scan.c             |   14 +
 drivers/scsi/scsi_sysfs.c            |    2 
 drivers/scsi/scsi_tgt_if.c           |    8 
 drivers/scsi/sgiwd93.c               |    5 
 drivers/scsi/wd33c93.c               |  321 ++++++++++++++++++++++++++---------
 drivers/scsi/wd33c93.h               |    6 
 include/scsi/scsi_tgt_if.h           |    3 
 include/scsi/scsi_transport.h        |    1 
 17 files changed, 481 insertions(+), 106 deletions(-)

James


