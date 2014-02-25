From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/10] qla4xxx: 5.04.00-k5: Updates for scsi "misc" branch
Date: Mon, 24 Feb 2014 22:06:55 -0500
Message-ID: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12050 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbaBYDnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:43:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest convenience.

Tej Parkash (5):
      qla4xxx: Do not wait for IO completion, after issuing stop_firmware
      qla4xxx: Change default capture to firmware defined capture mask
      qla4xxx: Add support of 0xFF capture mask for minidump
      qla4xxx: Added new opcodes for 84XX Minidump template
      qla4xxx: Added PEX DMA Support for ISP8022 Adapter

Vikas Chaudhary (5):
      qla4xxx: qla4xxx: Move qla4_8xxx_ms_mem_write_128b to ql4_nx.c
      qla4xxx: Check for correct return status
      qla4xxx: Initialize hardware queue for ISP40XX
      qla4xxx: Fix memory leak in func qla4_84xx_config_acb()
      qla4xxx: Update driver version to 5.04.00-k5

Thanks,
Vikas.
