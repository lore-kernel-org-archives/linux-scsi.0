From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/15] lpfc 8.2.8 : Update lpfc driver to 8.2.8
Date: Sun, 24 Aug 2008 21:48:51 -0400
Message-ID: <1219628931.7890.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52392 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYHYBst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:48:49 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1mmac019882
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:48:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The following patches raise the lpfc driver to revision 8.2.8

The following changes are included:
- Add kernel-doc function headers - part 1
- Add kernel-doc function headers - part 2
- Add kernel-doc function headers - part 3
- Add kernel-doc function headers - part 4
- Add kernel-doc function headers - part 5
- Miscellaneous Discovery fixes:
- Update driver for new SLI-3 features:
- Miscellaneous Fixes:
- Add new FCOE hardware support
- Add support for PCI-EEH permanent-disabling a device via lpfc_pci_remove_one()
- Update driver to use new Host byte error code DID_TRANSPORT_DISRUPTED.
- Added new sysfs attribute lpfc_max_scsicmpl_time. Attribute, when enabled,
  will control target queue depth based on I/O completion time.
- Add support for MSI-X Multi-Message interrupts. We use different vectors
  for fast-path interrupts (i/o) and slow-patch interrupts (discovery, etc).
- Added support for new sysfs attributes: lpfc_stat_data_ctrl and
  lpfc_max_scsicmpl_time. Added support for new fc vendor events for error
   reporting.
- Update lpfc driver version to 8.2.8

-- james s




