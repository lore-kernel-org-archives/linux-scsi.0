From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 0/5] bfa: code review fixes.
Date: Fri, 19 Mar 2010 11:04:57 -0700
Message-ID: <1269021897-9539-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:34425 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab0CSSRt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:17:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

This patch set is to address  review comments from upstream and Redhat.

Patch 1/5: addresses Jame's comments about using fc transport template for
vport create/delete.
Patch 2/5~5/5: address code review comments we received from Redhat. 

Jing Huang (5):
  bfa: add fc transport class based vport create/delete
  bfa: fix the issue of not handling scsi_cmnd sg chaining case
  bfa: use pci_iomap() and pci_iounmap()
  bfa: protect idr using bfad_mutex
  bfa: sg addr big endian fix

 drivers/scsi/bfa/bfa_cb_ioim_macros.h |   29 -----
 drivers/scsi/bfa/bfa_ioim.c           |   22 +++-
 drivers/scsi/bfa/bfa_os_inc.h         |   15 +++
 drivers/scsi/bfa/bfad.c               |   21 +---
 drivers/scsi/bfa/bfad_attr.c          |  201 +++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_drv.h           |    4 +-
 drivers/scsi/bfa/bfad_im.c            |   66 ++++++-----
 drivers/scsi/bfa/bfad_im.h            |    6 +-
 8 files changed, 283 insertions(+), 81 deletions(-)

