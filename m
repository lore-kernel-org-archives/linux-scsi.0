From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 00/28] be2iscsi: driver update 11.2.0.0
Date: Thu, 21 Jul 2016 14:37:37 +0530
Message-ID: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36854 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbcGUJI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:26 -0400
Received: by mail-wm0-f46.google.com with SMTP id q128so14798188wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

This patch is generated against for-next branch.

Jitendra Bhivare (28):
  be2iscsi: Fix to use correct configuration values
  be2iscsi: Replace _bh with _irqsave/irqrestore
  be2iscsi: Replace _bh version for mcc_lock spinlock
  be2iscsi: Reduce driver load/unload time
  be2iscsi: Set and return right iface v4/v6 states
  be2iscsi: Fix gateway APIs to support IPv4 & IPv6
  be2iscsi: Fix release of DHCP IP in static mode
  be2iscsi: Move VLAN code to common iface_set_param
  be2iscsi: Update iface handle before any set param
  be2iscsi: Rename iface get/set/create/destroy APIs
  be2iscsi: Handle only NET_PARAM in iface_get_param
  be2iscsi: Check all zeroes IP before issuing IOCTL
  be2iscsi: Remove alloc_mcc_tag & beiscsi_pci_soft_reset
  be2iscsi: Remove isr_lock and dead code
  be2iscsi: Fix checks for HBA in error state
  be2iscsi: Fix to make boot discovery non-blocking
  be2iscsi: Fix to add timer for UE detection
  be2iscsi: Add IOCTL to check UER supported
  be2iscsi: Move functions to right files
  be2iscsi: Fix POST check and reset sequence
  be2iscsi: Add V1 of EPFW cleanup IOCTL
  be2iscsi: Add TPE recovery feature
  be2iscsi: Fail the sessions immediately after TPE
  be2iscsi: Add FUNCTION_RESET during driver unload
  be2iscsi: Fix async PDU handling path
  be2iscsi: Update copyright information
  be2iscsi: Update the driver version
  MAINTAINERS: Update be2iscsi contact info

 MAINTAINERS                      |   10 +-
 drivers/scsi/be2iscsi/be.h       |   15 +-
 drivers/scsi/be2iscsi/be_cmds.c  | 1096 +++++++++++------
 drivers/scsi/be2iscsi/be_cmds.h  |  142 ++-
 drivers/scsi/be2iscsi/be_iscsi.c |  408 +++----
 drivers/scsi/be2iscsi/be_iscsi.h |   25 +-
 drivers/scsi/be2iscsi/be_main.c  | 2476 +++++++++++++++++++-------------------
 drivers/scsi/be2iscsi/be_main.h  |  220 ++--
 drivers/scsi/be2iscsi/be_mgmt.c  | 1490 +++++++++--------------
 drivers/scsi/be2iscsi/be_mgmt.h  |   51 +-
 10 files changed, 3052 insertions(+), 2881 deletions(-)

-- 
1.9.1

