From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH 0/7] Updates for be2iscsi driver
Date: Mon, 13 Aug 2012 15:59:20 +0530
Message-ID: <31d949d2-1fb6-488b-b5d4-e03574436cb9@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:48051 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HMKaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Aug 2012 06:30:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Jayamohan.Kallickal@Emulex.Com
Cc: John Soni Jose <sony.john-n@emulex.com>

 Patches to update the be2iscsi driver. These patches were generated
 against the scsi tree "scsi-misc" branch.

  Removing the iscsi_data_pdu setting.
  Issue MBX Cmd for login to boot target in crashdump mode
  Added Logging mechanism for the driver.
  Format the MAC_ADDR with sysfs_format_mac.
  Add support for configuring the VLAN on the adapter.
  Fix a kernel panic because of TCP RST/FIN received.
  Bump the driver version.
