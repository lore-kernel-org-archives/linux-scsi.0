From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/7] lpfc 8.1.5 : Patches for discovery bug fixes
Date: Sat, 15 Apr 2006 11:29:54 -0400
Message-ID: <1145114994.5837.13.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36019 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030272AbWDOPwo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:52:44 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFqfrf011020
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:52:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.1.5, which includes
the following changes:

 - Fix Discovery processing for NPorts that hit nodev_tmo during discovery
 - Use asynchronous ABTS completion to speed up abort completions
 - Fixed FC protocol violation in handling of PRLO.
 - Fix cleanup code in the lpfc_pci_probe_one() error code path.
 - Additional fixes to LOGO, PLOGI, and RSCN processing
 - Misc small fixes
   - Fix build warnings
   - Race condition in lpfc_workq_post_event() could corrupt phba->work_list.
   - nlp_sid was not being initialized properly
   - Fix some RSCN handling during the re-discovery after Link Up event.
 - Change version number to 8.1.5

-- james s



