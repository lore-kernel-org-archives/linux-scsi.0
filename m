From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/6] lpfc 8.1.7 patches
Date: Tue, 01 Aug 2006 07:32:52 -0400
Message-ID: <1154431972.18162.10.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60616 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932647AbWHALdC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Aug 2006 07:33:02 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BX1k8000863
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:33:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.1.8, which includes
the following changes:

 - Adding statistics reset callback for FC transport
 - Fix failing firmware download due to mailbox delays needing to be longer.
 - Fix race condition between lpfc_sli_issue_mbox and lpfc_online
 - Short bug fixes:
    - Fix iocbq list corruption due to missing list_del's in ct handling
    - Missing unlock in lpfc_sli_next_iotag()
    - Fix initialization of can_queue value
    - Differentiate sysfs mailbox errors with different codes.
 - ID String and Message fixes
    - Fix switch symbolic name registration to match cross-OS values
    - Replace printk's with more standard lpfc_printf_log calls
    - Make all lpfc_printf_log message numbers unique
 - Change version number to 8.1.8

-- james s




