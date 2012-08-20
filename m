From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 0/7] be2iscsi: Updates for be2iscsi driver
Date: Mon, 20 Aug 2012 22:59:48 +0530
Message-ID: <c3422502-db83-4580-8236-282e994c0086@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41617 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2HTRas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 13:30:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>

 Fixes done based on the review comments on previous submission.
 These patches were generated against the scsi tree "scsi-misc" 
 branch.

  be2iscsi: Removing the iscsi_data_pdu setting.
  be2iscsi: Issue MBX Cmd for login to boot target in crashdump mode
  be2iscsi: Added Logging mechanism for the driver.
  be2iscsi: Format the MAC_ADDR with sysfs_format_mac.
  be2iscsi: Add support for configuring the VLAN on the adapter.
  be2iscsi: Fix a kernel panic because of TCP RST/FIN received.
  be2iscsi: Bump the driver version.
