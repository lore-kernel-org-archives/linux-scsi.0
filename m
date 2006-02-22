From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/9] lpfc 8.1.3 driver update
Date: Wed, 22 Feb 2006 12:33:00 -0500
Message-ID: <43FCA04C.2020100@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47065 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030321AbWBVRdD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:33:03 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHX1rf029873
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:33:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch set updates the lpfc driver to revision 8.1.3, which includes
the following changes:

   - Derive supported speeds from LMT field in the READ_CONFIG
   - PCI hrd_type should be obtained with pci_read_config_byte() macro
   - Remove unused MBhostaddr from lpfc_sli structure
   - Fix performance when using multiple SLI rings
   - Fix deadlock in lpfc_fdmi_tmo_handler
   - Protect NPL lists with host lock
   - Fix polling mode panic
   - Adding hbaapi event support
   - Change version number to 8.1.3

-- james s


