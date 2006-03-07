From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/6] lpfc 8.1.4 : Driver Update for bug fixes
Date: Tue, 07 Mar 2006 15:02:12 -0500
Message-ID: <1141761732.25430.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:29132 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932100AbWCGUDc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 15:03:32 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k27K3Orf021469
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 12:03:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 8.1.4, which includes
the following changes:

 - Fix Discovery processing for NPorts that change their NPortId on the fly
 - Fixed RSCN handling when a PLOGI is in retry.
 - Fixed a timer panic due to timer firing after freeing ndlp
 - Introduce lpfc_reset_barrier() function for resets on dual channel adapters
 - Two misc fixes:
   - Fix deadlock caused by return with host_lock held in lpfc_findnode_did
   - Initialize all fields of the allocated mail box structure to zero.
     Was causing some sysfs mailbox commands to fail immediately after load.
 - Change version number to 8.1.4

-- james s




